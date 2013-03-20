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
<p>Ou nenhum par&acirc;metro foi enviado, ou um par&acirc;metro errado foi enviado, ou este n&uacute;mero de postagem n&atilde;o existe, ou algu&eacute;m apagou. Ou n&atilde;o.</p>
<p>Uso: http://iuri.blog.br/ler/?p=<i>NUMERO</i></p>
Onde <i>NUMERO</i> &eacute; o n&uacute;mero da postagem.</p>
<p><a href='../' target='_self'>Voltar para iuri.blog.br</a></p>
</body>
</html>

EOF
}

if (param('p')) {
	my ${postagem_numero} = param('p') or croak;
	if ( -f "../p/${postagem_numero}.post") {
		my ${postagem_disclaimer} = read_file("../p/${postagem_numero}.disc") or croak;
		my ${postagem_titulo} = read_file("../p/${postagem_numero}.t") or croak;
		my ${postagem_descricao} = read_file("../p/${postagem_numero}.desc") or croak;
		my ${postagem_conteudo} = read_file("../p/${postagem_numero}.post") or croak;
		my ${postagem_rodape} = read_file("../p/${postagem_numero}.r") or croak;
		my ${licenca} = read_file("../html/licenca.htm") or croak;
		print <<EOF or croak;
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
	<link rel='stylesheet' type='text/css' href='../css/post.css' />
<title>${postagem_titulo}</title>
</head>
<body>
<div class='principal'>
<p><a href='../' target='_self'>Voltar para iuri.blog.br</a></p>
<hr>
<h1>${postagem_titulo}</h1>
<h2>Disclaimer</h2>
${postagem_disclaimer}
<hr>
<h2>Descri&ccedil;&atilde;o/RSS</h2>
${postagem_descricao}
<hr>
<h2>Conte&uacute;do</h2>
${postagem_conteudo}
<hr>
${postagem_rodape}
<hr>
<div class='divisoria'></div>
</div>
<div class='rodape'>
${licenca}
</div>
</body>
</html>

EOF
	} else { croak; }
} else { croak; }

