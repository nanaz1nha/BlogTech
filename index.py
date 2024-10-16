# Importa a classe Flask do módulo flask
from flask import Flask, redirect, render_template, request, url_for
# Importa a bilbioteca de acesso ao MySQL
from flask_mysqldb import MySQL
# Importa todas funções dos artigos de `db_articles`
from functions.db_articles import *
from functions.db_comments import *
from functions.db_contacts import save_contact

# Cria uma instância da aplicação Flask
app = Flask(__name__)

# Dados de conexão
app.config['MYSQL_HOST'] = 'localhost'  # Endereço do servidor MySQL
app.config['MYSQL_USER'] = 'root'       # Nome de usuário do MySQL
app.config['MYSQL_PASSWORD'] = ''       # Senha do usuário do MySQL
app.config['MYSQL_DB'] = 'flaskblogdb'  # Nome do banco de dados

# Conecta o Python ao MySQL → `mysql` é a conexão com o banco de dados
mysql = MySQL(app)

########################
# Tratamento das rotas #
########################


@app.route('/')  # Define a rota para a URL raiz ('/')
def home():  # Função executada quando '/' é acessado

    articles = get_all(mysql)

    # Debug: mostra o resultado no console
    # print('\n\n\n',articles, '\n\n\n')

    # Variável da página HTML
    toPage = {
        # Valor da tag <title> → Título da página
        'title': 'FlaskBlog',
        # Nome da folha de estilos desta página (opcional)
        'css': 'home.css',
        # Nome do JavaScript desta página (opcional)
        # 'js': 'home.js',
        # Outros pares "chave" : "valor" entram aqui
        'articles': articles
    }

    # Abre a página de template → layout.html
    # Passa a variável local `toPage` para o template como `page`
    return render_template('home.html', page=toPage)


# Rota que exibe o artigo completo
@app.route('/view/<artid>')
def view(artid):

    # Obtém a variável 'ac' para mostrar feedback
    ac = request.args.get('ac')

    # Se o Id do artigo não é um número, exibe erro 404
    if not artid.isdigit():
        return page_not_found(404)

    article = get_one(mysql, artid)

    # Se o artigo não existe, exibe erro 404
    if article == None:
        return page_not_found(404)

    # Debug → Comente-me!
    # print('\n\n\n', article, '\n\n\n')

    # Atualiza vsualizações do artigo
    update_views(mysql, article['art_id'])

    # Obtém mais artigos do autor
    articles = get_by_author(mysql, article['sta_id'], article['art_id'])

    # Traduz o type do author
    match article['sta_type']:
        case 'admin':
            article['sta_typebr'] = 'Administrador'
        case 'author':
            article['sta_typebr'] = 'Autor'
        case 'moderator':
            article['sta_typebr'] = 'Moderador'
        case _:
            article['sta_typebr'] = 'Colaborador'

    # Primeiro nome do autor
    article['sta_firstname'] = article['sta_name'].split()[0]

    # Obtém todos os comentários do artigo
    comments = get_all_comments(mysql, article['art_id'])

    # Total de comentários
    total_comments = len(comments)

    # DEBUG → Comentários
    # print('\n\n\n', comments, '\n\n\n')

    toPage = {
        'title': '',
        'css': 'view.css',
        'article': article,     # Passa o artigo para a view.html
        'articles': articles,   # Lista de outros artigos do autor
        'action': ac,           # Feedback de envio do comentário
        'comments': comments,   # Todos os comentários deste artigo
        'total_comments': total_comments # Total de comentários
    }

    return render_template('view.html', page=toPage)


# Define a rota para a URL '/contatos' usando métodos GET e POST
@app.route('/contacts', methods=['GET', 'POST'])
def contacts():  # Função executada quando '/contacts' é acessado

    # Formulário não enviado por padrão
    success = False

    # Primeiro nome do remetente em branco
    first = ''

    # Se o formulário foi enviado
    if request.method == 'POST':

        # Recebe os dados do front-end (form)
        form = dict(request.form)

        # DEBUG → Testa de os dados do form foram recebidos
        # print('\n\n\n', form, '\n\n\n')

        # Salva contato no banco de dados
        success = save_contact(mysql, form)

        # Obtém o primeiro nome do remetente
        first = form['name'].split()[0]

    # Variável da página HTML
    toPage = {
        'title': 'Faça contato',
        'css': 'contacts.css',
        'success': success,
        'first': first
    }

    print('\n\n\n', toPage, '\n\n\n')

    # Retorna uma mensagem simples
    return render_template('contacts.html', page=toPage)


@app.errorhandler(404)  # Manipula o erro 404
def page_not_found(e):
    toPage = {
        'title': 'Erro 404',
        'css': '404.css'
    }
    return render_template('404.html', page=toPage), 404


@app.route('/comment', methods=['POST'])
def comment():

    # Recebe dados do formulário
    form = dict(request.form)

    # Teste de mesa
    # print('\n\n\n', form, '\n\n\n')

    # Salva o comentário
    save_comment(mysql, form)

    # Retorna para a visualização do artigo
    return redirect(url_for('view', artid=form['id'], ac='commented'))


# Verifica se o script está sendo executado diretamente
if __name__ == '__main__':
    # Inicia o servidor Flask em modo debug
    app.run(debug=True)
