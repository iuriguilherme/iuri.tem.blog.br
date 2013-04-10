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

my ${postagens_diretorio} = '../p';
my ${postagens_extensao} = 'post';

my @{postagens_arquivos} = glob "${postagens_diretorio}/*.${postagens_extensao}" or croak;
my ${postagens_total} = scalar(@{postagens_arquivos}) or croak;

print <<EOF;
Content-Type: text/html; charset=utf-8

${postagens_total}
EOF

