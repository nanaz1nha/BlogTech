from flask_mysqldb import MySQLdb


def save_contact(mysql, form):

    sql = '''
        INSERT INTO contact (
            name, email, subject, message
        ) VALUES (
            %s,
            %s,
            %s,
            %s
        )
    '''
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute(sql, (
        form['id'],         # Id do artigo
        form['name'],       # nome do autor do comentário
        form['email'],      # email do autor do comentário
        form['comment'],    # comentário
    ))
    mysql.connection.commit()
    cur.close()

    return True
