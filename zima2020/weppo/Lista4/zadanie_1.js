function Tree(val, left, right) {
    this.left = left;
    this.right = right;
    this.val = val;
}
Tree.prototype[Symbol.iterator] = function* () {
    let queue = [];
    queue.splice(queue.length, 0, this);
    while(queue.length !== 0){
        let firstElement = queue.splice(0, 1)[0];
        if(firstElement.right) queue.splice(queue.length, 0, firstElement.right);
        if(firstElement.left) queue.splice(queue.length, 0, firstElement.left);
        yield firstElement.val;
    }
}

var root = new Tree(1, new Tree(2, new Tree(3)), new Tree(4));
for (var e of root) {
    console.log(e);
}