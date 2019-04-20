


export tag Header < header
	def render
		<self>
			<a>
				<i> "Q"
				<i.fab.fa-github>
				<i.fab.fa-gitlab>
			<section>
				<label>
					<input type="text" placeholder="Поиск ... ">
				<span>
					<a .active=!window:location:hash href="/"> "Все фрагменты"
			<aside>
				<a .active=window:location:hash href="#Code" title="Новый фрагмент" > <i.fas.fa-plus-square>