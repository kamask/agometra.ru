import psycopg2
from random import random

density = {
  1: '155',
  2: '135',
  3: '125'
}

colors = {
  2: '00',
  3: '01',
  4: '02',
  5: '03',
  6: '04',
  7: '05',
  8: '06',
  9: '07',
  10: '08',
  11: '09',
  12: '10',
  13: '11'
}

#Test

sizes = {
  15: '00',
  16: '48',
  17: '50',
  18: '52',
  19: '54',
  20: '56'
}

conn = psycopg2.connect(dbname='agometra', user='agometra', password='Ago20metra20', host='localhost', port='64336')

db = conn.cursor()

# for d in range(1,4):
#   for c in range(2, 14):
#     for s in range(16, 21):
#       r = int(random() * 1000) * 10
#       p = 200 if d == 1 else 180 if d == 2 else 300
#       db.execute(f"insert into shirts(article, count, price, density_id, color_id, size_id) values('{str(density[d])+str(colors[c])+str(sizes[s])}', {r}, {p}, {d}, {c}, {s});")
      # print(f"insert into shirts(article, count, price, density_id, color_id, size_id) values('{str(density[d])+str(colors[c])+str(sizes[s])}', {r}, {p}, {d}, {c}, {s});")

conn.commit()

db.close()
conn.close()