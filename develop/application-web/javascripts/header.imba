import 'imba-router'
import State from './controller.imba'

export tag Header < header

	def render
		<self>
			<a route-to="/" :click.clickChangeCurrent>
				<i> "Q"
				<i.fab.fa-github>
				<i.fab.fa-gitlab>
			<section>
				<label> <input type="text" placeholder="Поиск ... ">
				<span> <a route-to="/"> "Все фрагменты"
			<aside>
				<a route-to="/code" title="Новый фрагмент" > <i.fas.fa-plus-square>