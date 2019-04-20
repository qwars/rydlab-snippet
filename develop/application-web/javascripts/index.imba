import style from './styleshets.imba'
import Header from './header.imba'

tag Main < main
    def render
        <self>

tag Footer < footer
    def render
        <self>

Imba.mount <Header>
Imba.mount <Main>
Imba.mount <Footer>