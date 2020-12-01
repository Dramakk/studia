console.log("Podaj swoje imię.");

var readable = process.stdin;
readable.setEncoding('utf8');

readable.on('data', (chunk) => {
    chunk = chunk.slice(0, chunk.length-1);
    console.log(`Witaj ${chunk}.`);
    process.exit(0);
});