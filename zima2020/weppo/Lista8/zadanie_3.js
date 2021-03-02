const { Client } = require('pg');
const client = new Client({
    user: 'weppo',
    host: 'localhost',
    database: 'zadania',
    password: '',
    port: 5432,
});

async function deleteFromDB(id) {
    const res = await client.query(`DELETE FROM Osoba WHERE id = ${id}`);
    console.log("Usunięto jeden rekord"); 

}

async function updatePerson(city, id = undefined) {
    let res = [];

    if(id === undefined){
        res = await client.query(`UPDATE Osoba SET miasto = '${city}'`);
        console.log("Pomyślnie zaktualizowano miejsce zamieszkania"); 
    }
    else{
        res = await client.query(`UPDATE Osoba SET miasto = '${city}' WHERE id = ${id}`);
        console.log("Pomyślnie zaktualizowano miejsce zamieszkania jednej osoby"); 
    }
}

async function doTask(){
    await client.connect();

    await deleteFromDB(4);
    await updatePerson("Szczecin", 5);

    await client.end();
}

doTask();