#!/usr/bin/perl -w

use strict;
use warnings;

use CGI qw(:standard);
use Scalar::Util qw(looks_like_number);
use File::Slurp;

sub croak {
print <<EOF or die "$0: @_: $!\n";
Content-Type: text/html; charset=utf-8

<div class='script_erro'>
<span>Erro: @_ $!</span>
</div>
EOF
}

my ${frases_diretorio} = '../p';
my ${frases_extensao} = 'frase';
my ${frases_parametro} = 'f';
my ${frase_estilo} = 'frase_normal';

my @{frases};
my @{frases_numeros};
my @{frases_arquivos} = glob "${frases_diretorio}/*.${frases_extensao}" or croak;

foreach my ${frase_numero} (@{frases_arquivos}) {
	${frase_numero} =~ s/\.${frases_extensao}$//;
	${frase_numero} =~ /([0-9]*)$/;
	${frase_numero} = ${1};
	push(@{frases_numeros},${frase_numero});
}
@{frases} = sort { ${b} <=> ${a} } @{frases_numeros};

my ${frase_destaque} = param(${frases_parametro}) || 0;
looks_like_number(${frase_destaque}) or croak "${frase_destaque} não é número!";

print "Content-Type: text/html; charset=utf-8\n\n";

foreach my ${frase_numero} (@{frases}) {
	my ${frase_conteudo} = read_file("${frases_diretorio}/${frase_numero}.${frases_extensao}") or croak;
	if (${frase_numero} == ${frase_destaque}) {
		${frase_estilo} = 'frase_destaque';
	} else {
		${frase_estilo} = 'frase_normal';
	}
	print <<EOF;
<tr>
	<td><a href='./?${frases_parametro}=${frase_numero}#${frase_numero}'>${frase_numero}</a></td>
	<td><a name='${frase_numero}' /><span class='${frase_estilo}'>${frase_conteudo}</span></td>
</tr>
EOF
}

