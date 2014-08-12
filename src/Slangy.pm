role Slangy;

token stopper { <!> }

token finishlex { <?> }

method panic(*@args) {
    self.typed_panic('X::Comp::AdHoc', payload => nqp::join('', @args))
}
method sorry(*@args) {
    self.typed_sorry('X::Comp::AdHoc', payload => nqp::join('', @args))
}
method worry(*@args) {
    self.typed_worry('X::Comp::AdHoc', payload => nqp::join('', @args))
}
method typed_panic($type_str, *%opts) {
    $*W.throw(self.MATCH(), nqp::split('::', $type_str), |%opts);
}
method typed_sorry($type_str, *%opts) {
    if +@*SORROWS + 1 == $*SORRY_LIMIT {
        $*W.throw(self.MATCH(), nqp::split('::', $type_str), |%opts);
    }
    else {
        @*SORROWS.push($*W.typed_exception(self.MATCH(), nqp::split('::', $type_str), |%opts));
    }
    self
}
method typed_worry($type_str, *%opts) {
    @*WORRIES.push($*W.typed_exception(self.MATCH(), nqp::split('::', $type_str), |%opts));
    self
}
method malformed($what) {
    self.typed_panic('X::Syntax::Malformed', :$what);
}
method missing($what) {
    self.typed_panic('X::Syntax::Missing', :$what);
}
method NYI($feature) {
    self.typed_panic('X::Comp::NYI', :$feature)
}

method MARKER(str $markname) {
    my Mu $shared = self.'!shared'();
    my Mu $markhash := nqp::getattr($shared, $shared.WHAT, '%!marks');
    my Mu $cur := nqp::atkey($markhash, $markname);
    if nqp::isnull($cur) {
        $cur := self."!cursor_start_cur"();
        $cur."!cursor_pass"(self.pos());
        nqp::bindkey($markhash, $markname, $cur);
    }
    else {
        $cur."!cursor_pos"(self.pos());
        $cur
    }
}

method MARKED(str $markname) {
    my Mu $shared = self.'!shared'();
    my Mu $markhash := nqp::getattr($shared, $shared.WHAT, '%!marks');
    my Mu $cur := nqp::atkey($markhash, $markname);
    unless nqp::istype($cur, Cursor) && $cur.pos() == self.pos() {
        $cur := self.'!cursor_start_fail'();
    }
    $cur
}
# vim: ft=perl6
