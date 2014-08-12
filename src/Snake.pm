use Snake::Actions;
use Snake::Grammar;

sub EXPORT(*@args) {
    %*LANG<Snake>           := Snake::Grammar;
    %*LANG<Snake-actions>   := Snake::Actions;

    $*MAIN := 'Snake';

    $*W.install_lexical_symbol($*W.cur_lexpad(), '%?LANG', $*W.p6ize_recursive(%*LANG));
    $*W.install_lexical_symbol($*W.cur_lexpad(), '$*MAIN', $*W.p6ize_recursive($*MAIN));

    $*W.p6ize_recursive( nqp::hash() )
}

# vim: ft=perl6
