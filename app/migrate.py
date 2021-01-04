import psycopg2
from config import DB_URL
from os import path, rename
from glob import glob

migrations_dir = path.join(path.dirname(__file__), 'migrations')


def migrate():
	conn = psycopg2.connect(DB_URL)
	db = conn.cursor()

	migrated = False

	db.execute("SELECT 1 FROM information_schema.tables WHERE table_name = 'migrations';")
	if not db.fetchall():
		print('Инициализация механизма миграций...')
		db.execute("""
			CREATE TABLE migrations (
			    id serial,
			    "name" varchar(6),
			    migrated_at timestamptz(0) NULL DEFAULT CURRENT_TIMESTAMP,
			    CONSTRAINT migrations_pk PRIMARY KEY (id)
			);
		""")
		print('Механизм миграций проинициализирован')
		migrations_files = glob(migrations_dir + '/*.sql')
		migrations_files.sort()

		for mf in migrations_files:
			with open(mf, 'r') as sql_file:
				name_migration = path.split(mf)[1][:6]
				db.execute(sql_file.read())
				db.execute(f"INSERT INTO migrations (name) VALUES ('{name_migration}')")
				print(name_migration + ' - ok')
				migrated = True

	db.execute('SELECT name FROM migrations ORDER BY name DESC LIMIT 1')
	last_migration = db.fetchall()[0][0]


	if path.exists(path.join(migrations_dir, 'new.sql')):
		with open(path.join(migrations_dir, 'new.sql'), 'r') as sql_file:
			name_migration = str(int(last_migration) + 1).zfill(6)
			db.execute(sql_file.read())
			db.execute(f"INSERT INTO migrations (name) VALUES ('{name_migration}')")
			print('\nnew.sql -> ' + name_migration + ' - ok')
			migrated = True
		rename(path.join(migrations_dir, 'new.sql'), path.join(migrations_dir, name_migration + '.sql'))
		db.execute('SELECT name FROM migrations ORDER BY name DESC LIMIT 1')
		last_migration = db.fetchall()[0][0]
	else:
		print('\nНовой миграции "new.sql" не обнаружено')


	conn.commit()
	db.close()
	conn.close()
	print(f"""
{'Все миграции применины.' if migrated else ''}

Для того что бы добавить миграцию, поместите файл "new.sql" в каталог с миграциями.

Последняя миграция - {last_migration}
""")

if __name__ == '__main__':
	migrate()
