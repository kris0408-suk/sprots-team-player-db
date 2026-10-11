import sqlite3
import pandas as pd
  
conn = sqlite3.connect('sports_team.db') 
conn.execute("DROP TABLE IF EXISTS PLAYER;")
 
conn.execute("""
CREATE TABLE PLAYER (
    PLAYER_ID INTEGER PRIMARY KEY,
    PLAYER_NAME TEXT NOT NULL UNIQUE,
    TEAM_NAME TEXT NOT NULL,
    JERSEY_NUMBER INTEGER,
    CAPTAIN TEXT DEFAULT 'NO'
);
""")
conn.commit()
print("Table created successfully!")

conn.execute("INSERT INTO Player VALUES (1, 'DHRITI', 'SHADOWS', 8, 'YES');")
conn.execute("INSERT INTO Player VALUES (2, 'RISHI', 'SHADOWS', 5, 'NO');")
conn.execute("INSERT INTO Player VALUES (3, 'TANUSH', 'FLASH', 11, 'NO');")
conn.execute("INSERT INTO Player VALUES (4, 'MINAKSHI', 'SHADOWS', 4, 'NO');")
conn.execute("INSERT INTO Player VALUES (5, 'VIRANG', 'FLASH', 1, 'YES');")
conn.execute("INSERT INTO Player VALUES (6, 'KAJAL', 'FLASH', 6);")
conn.commit()
print("Rows inserted successfully!")
 
players = pd.read_sql("SELECT * FROM PLAYER;", conn)
print(players)

print("\n--- Testing PRIMARY KEY ---")
try:
    conn.execute("INSERT INTO PLAYER VALUES (4, 'RAJ', 'MEGLADON', 9);")
    conn.commit()
except Exception as e:
    conn.rollback()
    print("Rejected:", e)
    print("PLAYER_ID 4 already belongs to MINAKSHI — PRIMARY KEY must be unique.")
 
print("\n--- Testing NOT NULL ---")
try:
    conn.execute("INSERT INTO Player VALUES (7, 'ARJUN', NULL, 6, 'NO');")
    conn.commit()
except Exception as e:
    conn.rollback()
    print("Rejected:", e)
    print("TEAM_NAME is NOT NULL — every player must have a team name.")
 
print("\n--- Testing UNIQUE ---")
try:
    conn.execute("INSERT INTO PLAYER VALUES (8, 'RISHI', 'MEGLADON', 12, 'NO');")
    conn.commit()
except Exception as e:
    conn.rollback()
    print("Rejected:", e)
    print("PLAYER_NAME is UNIQUE — 'Aarav' is already in the table.")

print("\n--- DEFAULT value check for KAJAL ---")
arjun = pd.read_sql("""SELECT PLAYER_NAME, TEAM_NAME, CAPTAIN
    FROM Player
    WHERE PLAYER_NAME == 'KAJAL';""", conn)
 
print(Kajal)
print("CAPTAIN was not given — DEFAULT 'NO' was used automatically.")

print("\n--- NULL in the Jersey_Number column ---")
all_players = pd.read_sql("""SELECT PLAYER_NAME, TEAM_NAME, JERSEY_NUMBER
    FROM PLAYER;""", conn)
 
print(all_players)
 
missing = pd.read_sql("""SELECT PLAYER_NAME FROM PLAYER
    WHERE JERSEY_NUMBER IS NULL;""", conn)
 
print("Players with no jersey number:")
print(missing)
 
has_data = pd.read_sql("""SELECT PLAYER_NAME, JERSEY_NUMBER FROM PLAYER
    WHERE JERSEY_NUMBER IS NOT NULL;""", conn)
 
print("Players with jersey numbers:")
print(has_data)
 
conn.close()
