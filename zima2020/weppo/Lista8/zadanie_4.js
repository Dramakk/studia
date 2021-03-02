const { Client } = require('pg');
const client = new Client({
    user: 'weppo',
    host: 'localhost',
    database: 'zadania',
    password: '',
    port: 5432,
});

async function createTableWorkplace() {
    const res = await client.query(`CREATE TABLE MIEJSCE_PRACY (id SERIAL PRIMARY KEY, nazwa TEXT)`);
    console.log("Stworzono tabelę workplace");

}

async function addKeyToOsoba() {
    const res = await client.query(`ALTER TABLE osoba ADD COLUMN id_miejsca_pracy INTEGER`); //tutaj piszemy normalne zapytanie SQL
    const res2 = await client.query(`ALTER TABLE osoba 
                                        ADD CONSTRAINT fk_id_miejsca_pracy
                                        FOREIGN KEY (id_miejsca_pracy) 
                                        REFERENCES miejsce_pracy(id)`);
    console.log("Dodano klucz obcy"); //tutaj mamy id właśnie wstawionej rzeczy, a dokładnie w res.rows[0].id
}

async function insertPersonIntoDB(name, surname, sex, pesel, city, workplaceId) {
    const res = await client.query(`INSERT INTO Osoba (imie, nazwisko, plec, pesel, miasto, id_miejsca_pracy) VALUES ('${name}',
                                    '${surname}', '${sex}', '${pesel}', '${city}', ${workplaceId}) RETURNING id`);
    console.log("Wstawiono nową osobę do bazy danych");
}

async function personWithWorkplace(name, surname, sex, pesel, city, workplaceName) {
    const res = await client.query(`INSERT INTO miejsce_pracy (nazwa) VALUES ('${workplaceName}') RETURNING id`);
    await insertPersonIntoDB(name, surname, sex, pesel, city, res.rows[0].id);
}

async function doTask() {
    await client.connect();

    //należy najpierw wykonać te dwie funkcje, a później je zakomentować
    // await createTableWorkplace();
    // await addKeyToOsoba();
    await personWithWorkplace("Anka", "Szklanka", "k", "99021212345", "Kamienna Góra", "Junior Node.js developer");
    await client.end();
}

doTask();