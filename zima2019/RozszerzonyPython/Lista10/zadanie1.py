from sqlalchemy import *
from sqlalchemy.ext.declarative import *
from sqlalchemy.orm import *
from sqlalchemy.databases import mysql
from sqlalchemy.engine.reflection import Inspector
import sys

engine = create_engine("mysql+mysqldb://books:12345@localhost/books", pool_recycle=3600, encoding='utf8', convert_unicode=True)
Session = sessionmaker(bind=engine)
sesja = Session()
Base = declarative_base()

class Books(Base):
    __tablename__ = "Books"
    id = Column(Integer, primary_key=True)
    Title = Column(String(20), nullable=False)
    Author = Column(String(50), nullable=False)
    Year_of_release = Column(Integer, nullable=False)


class Borrowed(Base):
    __tablename__ = "Borrowed"
    id = Column(Integer, primary_key=True)
    Name = Column(String(20), nullable=False)
    Email = Column(String(50), nullable=False)
    Borrowed_book_id = Column(Integer, ForeignKey("Books.id"))
    @validates("Email")
    def validate_email(self, key, value):
        assert "@" in value
        return value

def init():
    inspector = Inspector.from_engine(engine)
    tables = inspector.get_table_names()
    if "Books" not in tables or "Borrowed" not in tables:
        Base.metadata.create_all(engine)


def borrow_book(title, author, name, email):
    book_id = sesja.query(Books).filter(Books.Title == title, Books.Author == author).all()
    if book_id:
        book_id = book_id[0].id
        borrowed = sesja.query(Borrowed).filter(Borrowed.Borrowed_book_id == book_id).all()
        if borrowed:
            print("Książka już wypożyczona")
        else:
            new_borrowed_book = Borrowed(Name=name, Email=email, Borrowed_book_id=book_id)
            sesja.add(new_borrowed_book)
            sesja.commit()
            print("Pomyślnie wypożyczono książkę")


def unborrow_book(title, author):
    book_id = sesja.query(Books).filter(Books.Title == title, Books.Author == author).all()
    if book_id:
        book_id = book_id[0].id
        borrowed = sesja.query(Borrowed).filter(Borrowed.Borrowed_book_id == book_id).all()
        if borrowed:
            sesja.delete(borrowed[0])
            sesja.commit()
            print("Pomyślnie oddano książkę")
        else:
            print("Taka książka nie jest wypożyczona")

def add_book(title, author, year_of_release):
    book = sesja.query(Books).filter(Books.Title == title, Books.Author == author).all()
    if book:
        print("Książka jest już w bazie danych")
    else:
        new_book = Books(Title=title, Author=author, Year_of_release=year_of_release);
        sesja.add(new_book)
        sesja.commit()
        print("Pomyślnie dodano książkę")


init()
if __name__ == "__main__":
    args = sys.argv[1:]
    if args[0] == "--dodaj":
        args = args[1:]
        expected_args_len = 3
        expected_args = []
        if len(args) != expected_args_len:
            print("Proszę podać argumenty w poprawnym formacie")
            exit(0)
        for arg in args:
            pos_of_eq = arg.find("=")
            expected_args.append(arg[pos_of_eq+1:])
        add_book(expected_args[0], expected_args[1], expected_args[2])
    elif args[0] == "--wypozycz":
        args = args[1:]
        expected_args_len = 4
        expected_args = []
        if len(args) != expected_args_len:
            print("Proszę podać argumenty w poprawnym formacie")
            exit(0)
        for arg in args:
            pos_of_eq = arg.find("=")
            expected_args.append(arg[pos_of_eq+1:])
        borrow_book(expected_args[0], expected_args[1], expected_args[2], expected_args[3])
    elif args[0] == "--oddaj":
        args = args[1:]
        expected_args_len = 2
        expected_args = []
        if len(args) != expected_args_len:
            print("Proszę podać argumenty w poprawnym formacie")
            exit(0)
        for arg in args:
            pos_of_eq = arg.find("=")
            expected_args.append(arg[pos_of_eq+1:])
        unborrow_book(expected_args[0], expected_args[1])
    else:
        print("Nieznana opcja")
        exit(0)