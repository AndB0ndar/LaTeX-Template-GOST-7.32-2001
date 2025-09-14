# XeLaTeX configuration
$pdf_mode = 1;
$pdflatex = 'xelatex --shell-escape --synctex=1 %O %S';
$postscript_mode = 0;
$dvi_mode = 0;

# Build directory (improved handling)
$out_dir = 'build';
$aux_dir = 'build';
ensure_path($out_dir);

# Output verbosity (better error visibility)
$silent = 2;  # Show errors/warnings but suppress other output

# Viewer configuration (platform-independent)
$preview_continuous_mode = 1;
$pdf_previewer = 'start ""' if $^O eq 'MSWin32';  # Windows
$pdf_previewer = 'open' if $^O eq 'darwin';       # macOS
$pdf_previewer ||= 'xdg-open';                    # Linux/BSD

# Enhanced cleanup
$clean_full = 1;
$clean_ext = 'acn acr alg aux bbl bcf blg fls fdb_latexmk glg glo gls idx ilg ind ist log out run.xml toc lol lot lof snm nav synctex.gz vrb';

# Biber configuration (improved cross-platform handling)
$bibtex_use = 2;
add_cus_dep('bib', 'bbl', 0, 'run_biber');
sub run_biber {
    my $base = $_[0];
    if ($^O eq 'MSWin32') {
        system("biber --output-directory=$out_dir \"$base\"");
    } else {
        system("BIBER_OPT=\"--output-directory=$out_dir\" biber \"$base\"");
    }
}

# Dependency for glossaries (if needed)
# add_cus_dep('glo', 'gls', 0, 'makeglossaries');
sub makeglossaries {
    pushd();
    my $base = substr($_[0], 0, -4);
    system("makeglossaries -d $out_dir $base");
    popd();
}

