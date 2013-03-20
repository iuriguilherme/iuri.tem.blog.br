#!/usr/bin/perl -w

use strict;
use warnings;
use CGI qw(:standard);
use File::Slurp;

sub croak {
print <<EOF;
Content-Type: text/html; charset=utf-8

<!DOCTYPE html>
<html dir='auto' lang='pt-BR'>
<head>
	<meta charset='UTF-8' />
	<meta name='description' content="I.U.R.I. - Igreja Universal do Reino do IURI" />
	<meta name='keywords' content="I.U.R.I., iuri, iuri guilherme, iuri guilherme dos santos martins, porto alegre, expressão" />
	<link rel="shorcut icon" href='../favicon.ico' />
	<link rel='stylesheet' type='text/css' href='../css/styles.css' />
	<title>Erro</title>
</head>
<body>
<p>Ou nenhum par&acirc;metro foi enviado, ou um par&acirc;metro errado foi enviado, ou este n&uacute;mero da frase n&atilde;o existe, ou algu&eacute;m apagou. Ou n&atilde;o.</p>
<p>Uso: http://iuri.blog.br/frases/?f=<i>NUMERO</i></p>
Onde <i>NUMERO</i> &eacute; o n&uacute;mero da frase.</p>
<p>Ou simplesmente http://iuri.blog.br/frases/ para ler todas.</p>
<p><a href='http://iuri.blog.br' target='_self'>Voltar para iuri.blog.br</a></p>
</body>
</html>

EOF
}

my @{frases} = glob "../p/*.frase" or croak;
my ${frases_total} = scalar(@{frases});
my ${licenca} = read_file("../html/licenca.htm") or croak;
my ${frase_estilo} = 'frase_normal';

print <<EOF;
Content-Type: text/html; charset=utf-8

<!DOCTYPE html>
<html dir='auto' lang='pt-BR'>
<head>
	<meta charset='UTF-8' />
	<meta name='description' content="I.U.R.I. - Igreja Universal do Reino do IURI" />
	<meta name='keywords' content="I.U.R.I., iuri, iuri guilherme, iuri guilherme dos santos martins, porto alegre, expressão" />
	<link rel="shorcut icon" href='../favicon.ico' />
	<link rel='stylesheet' type='text/css' href='../css/styles.css' />
	<link rel='stylesheet' type='text/css' href='../css/rodape.css' />
	<link rel='stylesheet' type='text/css' href='../css/frases.css' />
<title>Frases de I.U.R.I.</title>
</head>
<body>
<div class='principal'>
<p><a href='../' target='_self'>Voltar para iuri.blog.br</a></p>
<hr>
<ul class='horizontal'>
EOF

foreach my ${frase} (@{frases}) {
	my ${frase_numero} = ${frase};
	${frase_numero} =~ s/\.frase$//;
	${frase_numero} =~ /([0-9]*)$/;
	${frase_numero} = $1;
	print <<EOF;
	\t<li><a href='./?f=${frase_numero}#${frase_numero}'>${frase_numero}</a></li>
EOF
}

print <<EOF;
</ul>
<table class='frases'>
	<caption><h2>Todas as frases</h2></caption>
	<thead>
	\t<tr>
	\t\t<td colspan='2'>Total de frases at&eacute; agora: ${frases_total}</td>
	\t</tr>
	</thead>
	<tbody>
EOF

foreach my ${frase} (@{frases}) {
	my ${frase_numero} = ${frase};
	${frase_numero} =~ s/\.frase$//;
	${frase_numero} =~ /([0-9]*)$/;
	${frase_numero} = $1;
	my ${frase_conteudo} = read_file("${frase}");
	if ((param('f')) && (param('f') == ${frase_numero})) {
		${frase_estilo} = 'frase_destaque';
	} else {
		${frase_estilo} = 'frase_normal';
	}
	print <<EOF;
	\t<tr>
	\t\t<td><a href='./?f=${frase_numero}#${frase_numero}'>${frase_numero}</a></td>
	\t\t<td><a name='${frase_numero}' /><span class='${frase_estilo}'>${frase_conteudo}</span></td>
	\t</tr>
EOF
}

print <<EOF;
	</tbody>
	<tfoot>
	\t<tr>
	\t\t<td colspan='2'>Total de frases at&eacute; agora: ${frases_total}</td>
	\t</tr>
	</tfoot>
</table>
<hr>
<p><a href='../' target='_self'>Voltar para iuri.blog.br</a></p>
<hr>
<div class='divisoria'></div>
</div>
<div class='rodape'>
<hr>
${licenca}
</div>
</body>
</html>

EOF

