import style from './styleshets.imba'

tag Header < header
    def render
        <self>

tag Main < main
    def render
        <self>

tag Footer < footer
    def render
        <self>

Imba.mount <Header>
Imba.mount <Main>
Imba.mount <Footer>