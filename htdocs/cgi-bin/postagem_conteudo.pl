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

my ${postagem_diretorio} = '../p';
my ${postagem_parametro} = 'p';
my ${postagem_numero} = param(${postagem_parametro}) || 0;
looks_like_number(${postagem_numero}) or croak "${postagem_numero} não é número!";
my ${postagem_conteudo} = read_file("${postagem_diretorio}/${postagem_numero}.post") or croak "Sem Conteúdo";
print "Content-Type: text/html; charset=utf-8\n\n${postagem_conteudo}";

