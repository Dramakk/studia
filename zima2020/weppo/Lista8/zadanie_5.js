const { Client } = require('pg');
const client = new Client({
    user: 'weppo',
    host: 'localhost',
    database: 'zadania',
    password: '',
    port: 5432,
});

async function createManyToManyRelation() {
    const res = await client.query(`CREATE TABLE miejsce_pracy_osoba (id SERIAL PRIMARY KEY, id_miejsca_pracy INTEGER, id_osoby INTEGER, 
        FOREIGN KEY (id_miejsca_pracy) REFERENCES miejsce_pracy(id), FOREIGN KEY (id_osoby) REFERENCES osoba(id))`);
    console.log("Stworzono relację many to many");

}

async function addPersonAndWorkplaceToRelation(personId, workplaceId){
    await client.query(`INSERT INTO miejsce_pracy_osoba (id_miejsca_pracy, id_osoby) VALUES (${workplaceId}, ${personId})`);
    console.log("Dodano osobę i miejsce pracy do relacji wiele do wielu");
}

async function insertPersonIntoDB(name, surname, sex, pesel, city, workplaceId) {
    const res = await client.query(`INSERT INTO Osoba (imie, nazwisko, plec, pesel, miasto) VALUES ('${name}',
                                    '${surname}', '${sex}', '${pesel}', '${city}') RETURNING id`);
    await addPersonAndWorkplaceToRelation(res.rows[0].id, workplaceId);
}

async function personWithWorkplace(name, surname, sex, pesel, city, workplaceName) {
    const res = await client.query(`INSERT INTO miejsce_pracy (nazwa) VALUES ('${workplaceName}') RETURNING id`);
    await insertPersonIntoDB(name, surname, sex, pesel, city, res.rows[0].id);
}

async function doTask() {
    await client.connect();

    //należy najpierw wykonać te dwie funkcje, a później je zakomentować
    // await createManyToManyRelation();
    await personWithWorkplace("Anka", "Szklanka", "k", "99021212345", "Kamienna Góra", "Junior Node.js developer");
    await client.end();
}

doTask();
