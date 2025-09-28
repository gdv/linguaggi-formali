# Output a pdf
$pdf_mode = 4;
#$pdflatex = 'pdflatex --shell-escape %O %S';
$lualatex = 'lualatex --file-line-error %O %S';

# By default compile only the file called 'main.tex'
@default_files = ('main.tex');

# Tikz figures
add_cus_dep('tikz', 'pdf', 1, 'latexmk');

# Compile the glossary and acronyms list (package 'glossaries')
add_cus_dep( 'acn', 'acr', 0, 'makeglossaries' );
add_cus_dep( 'glo', 'gls', 0, 'makeglossaries' );
$clean_ext .= " acr acn alg glo gls glg" .
  "deriv equ glo gls gsprogs hd listing lol" .
  " _minted-%R/* _minted-%R nav snm synctex.gz tcbtemp vpprogs";
sub makeglossaries {
   my ($base_name, $path) = fileparse( $_[0] );
   pushd $path;
   my $return = system "makeglossaries", $base_name;
   popd;
   return $return;
}

# Compile the nomenclature (package 'nomencl')
add_cus_dep( 'nlo', 'nls', 0, 'makenlo2nls' );
sub makenlo2nls {
    system( "makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"" );
}
