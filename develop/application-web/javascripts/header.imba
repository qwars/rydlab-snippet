


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
					<a .active=window:location:hash href="#Code"> "Новый фрагмент"
			<aside>