
import 'imba-router'

export tag Header < header
	def render
		<self>
			<a>
				<i> "Q"
				<i.fab.fa-github>
				<i.fab.fa-gitlab>
			<section>
				<label> <input type="text" placeholder="Поиск ... ">
				<span> <a route-to="/"> "Все фрагменты"
			<aside>
				<a route-to="/code" title="Новый фрагмент" > <i.fas.fa-plus-square>