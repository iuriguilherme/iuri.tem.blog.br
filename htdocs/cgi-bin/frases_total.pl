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

my @{frases_arquivos} = glob "${frases_diretorio}/*.${frases_extensao}" or croak;
my ${frases_total} = scalar(@{frases_arquivos}) or croak;

print "Content-Type: text/html; charset=utf-8\n\n${frases_total}";

