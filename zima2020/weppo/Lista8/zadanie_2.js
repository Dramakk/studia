const { Client } = require('pg');
const client = new Client({
    user: 'weppo',
    host: 'localhost',
    database: 'zadania',
    password: '',
    port: 5432,
});

async function getDataFromDB() {
    const res = await client.query('SELECT * FROM Osoba'); //tutaj piszemy normalne zapytanie SQL

    console.log(res.rows); //wynik zapytania
}

async function insertDataIntoDB(name, surname, sex, pesel, city) {
    const res = await client.query(`INSERT INTO Osoba (imie, nazwisko, plec, pesel, miasto) VALUES ('${name}',
                                    '${surname}', '${sex}', '${pesel}', '${city}') RETURNING id`); //tutaj piszemy normalne zapytanie SQL

    console.log(res.rows); //tutaj mamy id właśnie wstawionej rzeczy, a dokładnie w res.rows[0].id.
}

async function doTask(){
    await client.connect();

    await getDataFromDB();
    await insertDataIntoDB("Anka", "Szklanka", "k", "99021212345", "Kamienna Góra");

    await client.end();
}

doTask();