#!/usr/bin/perl -w

use strict;
use warnings;

use File::Slurp;
use DateTime::Format::Mail;
use Encode qw(encode);

sub croak {
print <<EOF or die "$0: @_: $!\n";
Content-Type: text/html; charset=utf-8

<div class='script_erro'>
<tr>
	<td colspan='3'><span>Erro: @_ $!</span></td>
</tr>
</div>
EOF
}

DateTime->DefaultLocale("pt_BR.UTF-8");

my ${postagens_diretorio} = '../p';
my ${postagens_extensao} = 'post';
my ${postagem_titulo_extensao} = 't';
my ${postagem_fonte_extensao} = 'src';
my ${postagem_categoria_extensao} = 'cat';
my ${postagem_data_extensao} = 'data';

my ${ler_postagem_diretorio} = './ler';
my ${ler_postagem_parametro} = 'p';
my ${rss_diretorio} = './rss';
my ${rss_extensao} = 'rss';

my ${parametros_link_padrao} = 'target="_self"';
my ${parametros_link_externo} = 'target="_blank"';
my ${parametros_link_rss} = 'type="application/rss+xml"';

my ${imagens_diretorio} = '../html/index/body/img';
my ${imagem_ler} = read_file(${imagens_diretorio}.'/ler.htm') or croak;
my ${imagem_rss} = read_file(${imagens_diretorio}.'/rss.htm') or croak;
my ${imagem_fonte} = read_file(${imagens_diretorio}.'/fonte.htm') or croak;

my @{postagens};
my @{postagens_numeros};
my @{postagens_arquivos} = glob "${postagens_diretorio}/*.${postagens_extensao}" or croak;

foreach my ${postagem_numero} (@{postagens_arquivos}) {
	${postagem_numero} =~ s/\.${postagens_extensao}$//;
	${postagem_numero} =~ /([0-9]*)$/;
	${postagem_numero} = ${1};
	push(@{postagens_numeros},${postagem_numero});
}

@{postagens} = sort { ${b} <=> ${a} } @{postagens_numeros};

print "Content-Type: text/html; charset=utf-8\n\n";

foreach my ${postagem_numero} (@{postagens}) {
	my ${postagem_titulo} = read_file("${postagens_diretorio}/${postagem_numero}.${postagem_titulo_extensao}") or croak;
	my ${postagem_fonte} = read_file("${postagens_diretorio}/${postagem_numero}.${postagem_fonte_extensao}") or croak;
	my ${postagem_categoria} = read_file("${postagens_diretorio}/${postagem_numero}.${postagem_categoria_extensao}") or croak;
	my ${postagem_data} = encode('UTF-8',DateTime::Format::Mail->parse_datetime(read_file("${postagens_diretorio}/${postagem_numero}.${postagem_data_extensao}"))->strftime('%F')) or croak;
	if ((-f "${postagens_diretorio}/${postagem_numero}.${postagem_categoria_extensao}") && (-f "${postagens_diretorio}/${postagem_numero}.${postagem_data_extensao}") && (-f "${postagens_diretorio}/${postagem_numero}.${postagem_titulo_extensao}") && (-f "${postagens_diretorio}/${postagem_numero}.${postagem_fonte_extensao}")) {
		print <<EOF;
<tr>
<td>
<ul class='horizontal'>
	<li><a href='${ler_postagem_diretorio}/?${ler_postagem_parametro}=${postagem_numero}' ${parametros_link_padrao}>${postagem_numero}</a>
	<li><a href='${ler_postagem_diretorio}/?${ler_postagem_parametro}=${postagem_numero}' ${parametros_link_padrao}>${imagem_ler}</a></li>
	<li><a href='${rss_diretorio}/${postagem_categoria}.${rss_extensao}' ${parametros_link_rss} ${parametros_link_externo}>${imagem_rss}</a></li>
	<li><a href='${postagem_fonte}' ${parametros_link_externo}>${imagem_fonte}</a></li>
</ul>
</td>
<td><a href='${ler_postagem_diretorio}/?${ler_postagem_parametro}=${postagem_numero}' ${parametros_link_padrao}>${postagem_titulo}</a></td>
<td><a href='${ler_postagem_diretorio}/?${ler_postagem_parametro}=${postagem_numero}' ${parametros_link_padrao}>${postagem_data}</a></td>
</tr>
EOF
	}
}

