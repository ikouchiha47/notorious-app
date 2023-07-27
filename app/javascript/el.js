export function $(el) {
    return document.querySelector(el);
}


export function $hide(el) {
    if(!hasClassList(el)) {
        return;
    }


    if (isHidden(el)) {
        return;
    }

    el.classList.remove('revealum');
    el.classList.add('pooff');
}

export function $show(el) {
    if(!hasClassList(el)) {
        return;
    }


    if (el.classList.contains('revealum')) {
        return;
    }

    el.classList.remove('pooff');
    el.classList.add('revealum');
}


export function $toggle(el) {
    if(!hasClassList(el)) {
        return;
    }

    if(isHidden(el)) {
        $show(el);
        return;
    }

    $hide(el);
}

export function $toggleClass(el, klassName) {
    if(!hasClassList(el)) {
        return;
    }

    if (el.classList.contains(klassName)) {
        el.classList.remove(klassName);
    } else {
        el.classList.add(klassName);
    }

}

function isHidden(el) {
    return el.classList.contains("pooff");
}

function hasClassList(el) {
    if(!el) return false;
    if(el && !el.classList) return false;

    return true;
}
 
