const cartdbKey = 'cartContents';
let initialState = { lengrh: 0 };

export function checkItemPresent(itemID) {
    let data = loadDB();
    return data ? data.filter(d => d).find(item => item.itemID == itemID): null;
}

export function addCartItem({ size, itemID }) {
    let itemsInCart = loadDB();

    if(!itemsInCart) { return null; }

    itemsInCart[itemID] = size;
    itemsInCart.length = (itemsInCart.length || 0) + 1;

    writeToDB(itemsInCart);
    return itemsInCart.length;
}

export function updateItem({ size, itemID }) {
    let itemsInCart = loadDB();

    if(!itemsInCart) { itemsInCart = writeToDB(initialState); }

    let item = itemsInCart[itemID];
    if(!item) { return null; }

    itemsInCart[itemID] = size;
    writeToDB(itemsInCart);

    return 1;
}

export function countItems() {
    let items = loadDB();
    return items ? items.length : 0;
}

function loadDB() {
    try {
        let data = localStorage.getItem(cartdbKey) || JSON.stringify(initialState);
        let itemsInCart = JSON.parse(data);

        return itemsInCart;
    } catch(e) {
        return null;
    }
}

function writeToDB(data) {
    localStorage.setItem(cartdbKey, JSON.stringify(data));
    return data;
}
