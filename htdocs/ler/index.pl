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
	<meta name='description' content="I.U.R.I. - Igreja Universal do Reino do IURI" />
	<meta name='keywords' content="I.U.R.I., iuri, iuri guilherme, iuri guilherme dos santos martins, porto alegre, expressão" />
	<link rel="shorcut icon" href='../favicon.ico' />
	<link rel='stylesheet' type='text/css' href='../css/styles.css' />
	<title>Erro</title>
</head>
<body>
<p>Ou nenhum par&acirc;metro foi enviado, ou um par&acirc;metro errado foi enviado, ou este n&uacute;mero de postagem n&atilde;o existe, ou algu&eacute;m apagou. Ou n&atilde;o.</p>
<p>Uso: http://iuri.blog.br/ler/?p=<i>NUMERO</i></p>
Onde <i>NUMERO</i> &eacute; o n&uacute;mero da postagem.</p>
<p><a href='../' target='_self'>Voltar para iuri.blog.br</a></p>
</body>
</html>

EOF
}

if (param('p')) {
	my $post_numero = param('p') or croak;
	if ( -f "../p/$post_numero.post") {
		my $post_disclaimer = read_file("../p/$post_numero.disc") or croak;
		my $post_titulo = read_file("../p/$post_numero.t") or croak;
		my $post_descricao = read_file("../p/$post_numero.desc") or croak;
		my $post_conteudo = read_file("../p/$post_numero.post") or croak;
		my $post_rodape = read_file("../p/$post_numero.r") or croak;
		my $post_licenca = read_file("../html/licenca.htm") or croak;
		print <<EOF or croak;
Content-Type: text/html; charset=utf-8

<!DOCTYPE html>
<html dir='auto' lang='pt-BR'>
<head>
	<meta name='description' content="I.U.R.I. - Igreja Universal do Reino do IURI" />
	<meta name='keywords' content="I.U.R.I., iuri, iuri guilherme, iuri guilherme dos santos martins, porto alegre, expressão" />
	<link rel="shorcut icon" href='../favicon.ico' />
	<link rel='stylesheet' type='text/css' href='../css/styles.css' />
	<link rel='stylesheet' type='text/css' href='../css/rodape.css' />
	<link rel='stylesheet' type='text/css' href='../css/post.css' />
<title>$post_titulo</title>
</head>
<body>
<div class='principal'>
<p><a href='../' target='_self'>Voltar para iuri.blog.br</a></p>
<hr>
<h1>$post_titulo</h1>
<h2>Disclaimer</h2>
$post_disclaimer
<hr>
<h2>Descri&ccedil;&atilde;o/RSS</h2>
$post_descricao
<hr>
<h2>Conte&uacute;do</h2>
$post_conteudo
<hr>
$post_rodape
<hr>
<div class='divisoria'></div>
</div>
<div class='rodape'>
$post_licenca
</div>
</body>
</html>

EOF
	} else { croak; }
} else { croak; }

