#!/usr/bin/perl -w

use strict;
use warnings;

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

my @{frases};
my @{frases_numeros};
my @{frases_arquivos} = glob "${frases_diretorio}/*.${frases_extensao}" or croak;

foreach my ${frase_numero} (@{frases_arquivos}) {
	${frase_numero} =~ s/\.${frases_extensao}$//;
	${frase_numero} =~ /([0-9]*)$/;
	${frase_numero} = ${1};
	push(@{frases_numeros},${frase_numero});
}
@{frases} = sort { $a <=> $b } @{frases_numeros};

print "Content-Type: text/html; charset=utf-8\n\n";

foreach my ${frase_numero} (@{frases}) {
	print <<EOF;
	\t<li><a href='./?${frases_parametro}=${frase_numero}#${frase_numero}'>${frase_numero}</a></li>
EOF
}

