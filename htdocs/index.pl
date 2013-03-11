#!/usr/bin/perl -w

use strict;
use warnings;
use CGI qw(:standard);
use File::Slurp;
use DateTime::Format::Mail;
use Encode qw(encode);

sub croak {
print <<EOF;
Content-Type: text/html; charset=utf-8

<!DOCTYPE html>
<html dir='auto' lang='pt-BR'>
<head>
	<meta name='description' content="I.U.R.I. - Igreja Universal do Reino do IURI" />
	<meta name='keywords' content="I.U.R.I., iuri, iuri guilherme, iuri guilherme dos santos martins, porto alegre, expressão" />
	<link rel="shorcut icon" href='./favicon.ico' />
	<link rel='stylesheet' type='text/css' href='./css/styles.css' />
	<title>Erro</title>
</head>
<body>
<p>O Iuri deve ter deixado alguma coisa errada em algum c&oacute;digo em algum lugar. Ou o servidor n&atilde;o est&aacute; de boa vontade hoje. Tente novamente mais tarde. Ou n&atilde;o.</p>
<p><a href='http://iuri.blog.br/' target='_self'>Recarregar</a></p>
</body>
</html>

EOF
}

DateTime->DefaultLocale("pt_BR.UTF-8");

my $index_meta = read_file("./html/index_metadados.htm") or croak;
my $index_cabecalho = read_file("./html/index_cabecalho.htm") or croak;
my $index_corpo_rss = read_file("./html/index_corpo_rss.htm") or croak;
my $index_corpo_posts_cima = read_file("./html/index_corpo_posts_cima.htm") or croak;
my $index_corpo_posts_baixo_1 = read_file("./html/index_corpo_posts_baixo_1.htm") or croak;
my $index_corpo_posts_baixo_2 = read_file("./html/index_corpo_posts_baixo_2.htm") or croak;
my $index_rodape_cima = read_file("./html/index_rodape_cima.htm") or croak;
my $index_rodape_baixo = read_file("./html/index_rodape_baixo.htm") or croak;
my $licenca = read_file("./html/licenca.htm") or croak;

my @postagens = glob "./p/*.post" or croak;
my $postagens_total = scalar(@postagens);

print <<EOF;
Content-Type: text/html; charset=utf-8

$index_meta
$index_cabecalho
$index_corpo_rss
$index_corpo_posts_cima
EOF

foreach my $postagem (@postagens) {
	$postagem =~ s/\.post$//;
	my $post_numero = $postagem;
	$post_numero =~ /([0-9]*)$/;
	$post_numero = $1;
	my $post_titulo = read_file("$postagem.t");
	my $post_fonte = read_file("$postagem.src");
	my $post_categoria = read_file("$postagem.cat");
	my $post_data = encode('UTF-8',DateTime::Format::Mail->parse_datetime(read_file("$postagem.data"))->strftime('%F'));
	if ((-f "$postagem.t") && (-f "$postagem.src") && (-f "$postagem.data")) {
		print <<EOF;
		\t<tr>
		\t\t<td><span class='justificado'>
		\t\t\t<ul class='horizontal'>
		\t\t\t\t<li><a href='./ler/?p=$post_numero' target='_self'>$post_numero</a>
		\t\t\t\t<li><a href='./ler/?p=$post_numero' target='_self'><img alt="Ler" text="Ler" height='16' src='./img/ler.png' /></a></li>
		\t\t\t\t<li><a href='./rss/$post_categoria.rss' type='application/rss+xml' target='_blank'><img src='./img/rss-feed.png' alt='RSS' width='16' height='16' /></a></li>
		\t\t\t\t<li><a href='$post_fonte' target='_blank'><img alt="Link externo" width='16' height='16' src='./img/emblem-symbolic-link.png'/></a></li>
		\t\t\t</ul>
		\t\t</span></td>
		\t\t<td><a href='./ler/?p=$post_numero' target='_self'>$post_titulo</a></td>
		\t\t<td><a href='./ler/?p=$post_numero' target='_self'>$post_data</a></td>
		\t</tr>
EOF
	}
}
print <<EOF;
$index_corpo_posts_baixo_1
\t\t\t<td>$postagens_total</td>
$index_corpo_posts_baixo_2
$index_rodape_cima
$licenca
$index_rodape_baixo

EOF

