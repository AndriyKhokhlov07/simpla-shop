{capture name=tabs}
	{if in_array('pages', $manager->permissions)}
	{foreach $menus  as $m}
		<li {if $m->id == $menu->id}class="active"{/if}><a href='index.php?module=PagesAdmin&menu_id={$m->id}'>{$m->name}</a></li>
	{/foreach}
	{/if}
{/capture}

{if $page->id}
{$meta_title = $page->name scope=parent}
{else}
{$meta_title = 'Новая страница' scope=parent}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script src="design/js/jquery/jquery.js"></script>
<script src="design/js/jquery/jquery-ui.min.js"></script>


<script>
$(function() {

	// Удаление изображений
	$(".images a.delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	// Автозаполнение мета-тегов
	menu_item_name_touched = true;
	meta_title_touched = true;
	meta_keywords_touched = true;
	meta_description_touched = true;
	url_touched = true;
	
	if($('input[name="menu_item_name"]').val() == generate_menu_item_name() || $('input[name="name"]').val() == '')
		menu_item_name_touched = false;
	if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
		meta_title_touched = false;
	if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
		meta_keywords_touched = false;
	if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
		meta_description_touched = false;
	if($('input[name="url"]').val() == generate_url())
		url_touched = false;
		
	$('input[name="name"]').change(function() { menu_item_name_touched = true; });
	$('input[name="meta_title"]').change(function() { meta_title_touched = true; });
	$('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
	$('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });
	$('input[name="url"]').change(function() { url_touched = true; });
	
	$('input[name="header"]').keyup(function() { set_meta(); });
});

function set_meta()
{
	if(!menu_item_name_touched)
		$('input[name="name"]').val(generate_menu_item_name());
	if(!meta_title_touched)
		$('input[name="meta_title"]').val(generate_meta_title());
	if(!meta_keywords_touched)
		$('input[name="meta_keywords"]').val(generate_meta_keywords());
	if(!meta_description_touched)
	{
		descr = $('textarea[name="meta_description"]');
		descr.val(generate_meta_description());
		descr.scrollTop(descr.outerHeight());
	}
	if(!url_touched)
		$('input[name="url"]').val(generate_url());
}

function generate_menu_item_name()
{
	name = $('input[name="header"]').val();
	return name;
}

function generate_meta_title()
{
	name = $('input[name="header"]').val();
	return name;
}

function generate_meta_keywords()
{
	name = $('input[name="header"]').val();
	return name;
}

function generate_meta_description()
{
	if(typeof(tinyMCE.get("body")) =='object')
	{
		description = tinyMCE.get("body").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
		return description;
	}
	else
		return $('textarea[name=body]').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
}

function generate_url()
{
	url = $('input[name="header"]').val();
	url = url.replace(/[\s]+/gi, '-');
	url = translit(url);
	url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();	
	return url;
}

function translit(str)
{
	let ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")
	let en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")
 	let res = '';
	for(let i=0, l=str.length; i<l; i++)
	{ 
		let s = str.charAt(i), n = ru.indexOf(s);
		if(n >= 0) { res += en[n]; } 
		else { res += s; } 
    } 
    return res;  
}


</script>


{/literal}


{if $message_success}
<!-- Системное сообщение -->
<div class="message message_success">
	<span class="text">{if $message_success == 'added'}Страница добавлена{elseif $message_success == 'updated'}Страница обновлена{/if}</span>
	<a class="link" target="_blank" href="../{$page->url}">Открыть страницу на сайте</a>
	{if $smarty.get.return}
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
	
	<span class="share">		
		<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/{$page->url|urlencode}&title={$page->name|urlencode}&description={$page->body|urlencode}&noparse=false","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/simpla/design/images/vk_icon.png" /></a>
		<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/{$page->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/simpla/design/images/facebook_icon.png" /></a>
		<a href="#" onClick='window.open("http://twitter.com/share?text={$page->name|urlencode}&url={$config->root_url|urlencode}/{$page->url|urlencode}&hashtags={$page->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/simpla/design/images/twitter_icon.png" /></a>
	</span>
	
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">{if $message_error == 'url_exists'}Страница с таким адресом уже существует{/if}</span>
	<a class="button" href="">Вернуться</a>
</div>
<!-- Системное сообщение (The End)-->
{/if}



<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
	<div id="name">
		<input class="name" name=header type="text" value="{$page->header|escape}"/> 
		<input name=id type="hidden" value="{$page->id|escape}"/> 
		<div class="checkbox">
			<input name=visible value='1' type="checkbox" id="active_checkbox" {if $page->visible}checked{/if}/> <label for="active_checkbox">Активна</label>
		</div>
	</div> 

		<!-- Параметры страницы -->
		<div class="block">
			<ul>
				<li><label class=property>Название пункта в меню</label><input name="name" class="simpla_inp" type="text" value="{$page->name|escape}" /></li>
				<li><label class=property>Меню</label>	
					<select name="menu_id">
				   		{foreach $menus as $m}
				        	<option value='{$m->id}' {if $page->menu_id == $m->id}selected{/if}>{$m->name|escape}</option>
				    	{/foreach}
					</select>		
				</li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->

	<!-- Левая колонка свойств товара -->
	<div id="column_left">
			
		<!-- Параметры страницы -->
		<div class="block layer">
			<h2>Параметры страницы</h2>
			<ul>
				<li><label class=property>Адрес</label><div class="page_url">/</div><input name="url" class="page_url" type="text" value="{$page->url|escape}" /></li>
				<li><label class=property>Заголовок</label><input name="meta_title" class="simpla_inp" type="text" value="{$page->meta_title|escape}" /></li>
				<li><label class=property>Ключевые слова</label><input name="meta_keywords" class="simpla_inp" type="text" value="{$page->meta_keywords|escape}" /></li>
				<li><label class=property>Описание</label><textarea name="meta_description" class="simpla_inp"/>{$page->meta_description|escape}</textarea></li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->
			
	</div>
	<!-- Левая колонка свойств товара (The End)-->

	<!-- Правая колонка свойств товара -->
	<div id="column_right">

		<!-- Изображение категории -->
		<div class="block layer images">
			<h2>Добавить Изображение</h2>
			<input class='upload_image' name=image type=file>
			<input type=hidden name="delete_image" value="">
			{if $page->image}
				<ul>
					<li>
						<a href='#' class="delete"><img src='design/images/cross-circle-frame.png'></a>
						<img src="../{$config->pages_images_dir}{$page->image}" alt="" />
					</li>
				</ul>
			{/if}
		</div>

	</div>
	<!-- Правая колонка свойств товара (The End)-->

	<!-- Описагние товара -->
	<div class="block layer">
		<h2>Текст страницы</h2>
		<textarea name="body"  class="editor_large">{$page->body|escape}</textarea>
	</div>
	<!-- Описание товара (The End)-->
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	
</form>
<!-- Основная форма (The End) -->

