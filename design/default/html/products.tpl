{* Список товаров *}

{* Канонический адрес страницы *}
{if $category && $brand}
{$canonical="/catalog/{$category->url}/{$brand->url}" scope=parent}
{elseif $category}
{$canonical="/catalog/{$category->url}" scope=parent}
{elseif $brand}
{$canonical="/brands/{$brand->url}" scope=parent}
{elseif $keyword}
{$canonical="/products?keyword={$keyword|escape}" scope=parent}
{else}
{$canonical="/products" scope=parent}
{/if}

<!-- Хлебные крошки /-->
<div id="path">
	<a href="/">Главная</a>
	{if $category}
	{foreach $category->path as $cat}
	→ <a href="catalog/{$cat->url}">{$cat->name|escape}</a>
	{/foreach}  
	{if $brand}
	→ <a href="catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a>
	{/if}
	{elseif $brand}
	→ <a href="brands/{$brand->url}">{$brand->name|escape}</a>
	{elseif $keyword}
	→ Поиск
	{/if}
</div>
<!-- Хлебные крошки #End /-->

{* Заголовок страницы *}
{if $keyword}
<h1>Поиск {$keyword|escape}</h1>
{elseif $page}
<h1>{$page->name|escape}</h1>
{else}
<h1>{$category->name|escape} {$brand->name|escape}</h1>
{/if}


{* Описание страницы (если задана) *}
{$page->body}

{if $current_page_num==1}
{* Описание категории *}
{$category->description}
{/if}

{* Фильтр по брендам *}
{if $category->brands}
<div id="brands">
	<a href="catalog/{$category->url}" {if !$brand->id}class="selected"{/if}>Все бренды</a>
	{foreach $category->brands as $b}
		{if $b->image}
		<a data-brand="{$b->id}" href="catalog/{$category->url}/{$b->url}"><img src="{$config->brands_images_dir}{$b->image}" alt="{$b->name|escape}"></a>
		{else}
		<a data-brand="{$b->id}" href="catalog/{$category->url}/{$b->url}" {if $b->id == $brand->id}class="selected"{/if}>{$b->name|escape}</a>
		{/if}
	{/foreach}
</div>
{/if}

{if $current_page_num==1}
{* Описание бренда *}
{$brand->description}
{/if}

{* Фильтр по свойствам *}
{if $features}
<table id="features">
	{foreach $features as $key=>$f}
	<tr>
	<td class="feature_name" data-feature="{$f->id}">
		{$f->name}:
	</td>
	<td class="feature_values">
		<a href="{url params=[$f->id=>null, page=>null]}" {if !$smarty.get.$key}class="selected"{/if}>Все</a>
		{foreach $f->options as $o}
		<a href="{url params=[$f->id=>$o->value, page=>null]}" {if $smarty.get.$key == $o->value}class="selected"{/if}>{$o->value|escape}</a>
		{/foreach}
	</td>
	</tr>
	{/foreach}
</table>
{/if}


<!--Каталог товаров-->
{if $products}

{* Сортировка *}
{if $products|count>0}
<div class="sort">
	Сортировать по 
	<a {if $sort=='position'} class="selected"{/if} href="{url sort=position page=null}">умолчанию</a>
	<a {if $sort=='price'}    class="selected"{/if} href="{url sort=price page=null}">цене</a>
	<a {if $sort=='name'}     class="selected"{/if} href="{url sort=name page=null}">названию</a>
</div>
{/if}


{include file='pagination.tpl'}


	<!-- Список товаров-->
	<div class="products">

		{foreach $products as $product}
			<!-- Товар-->
			<li class="product">
				<form class="variants" action="/cart">
					<div class="top_bx">

						<!-- Фото товара -->
						{if $product->image}
							<div class="image">
								<a href="products/{$product->url}"><img src="{$product->image->filename|resize:200:200}" alt="{$product->name|escape}"/></a>
							</div>
						{/if}
						<!-- Фото товара (The End) -->

						<!-- Ціна товара -->
						<div class="price {if $product->variant->price == 0}hide{/if}">
							<span>{$product->variant->price|convert}</span> {$currency->sign|escape}
						</div>
						<!-- Ціна товара (The End) -->

						<!-- Название товара -->
						<h3 class="{if $product->featured}featured{/if}"><a data-product="{$product->id}" href="products/{$product->url}">{$product->name|escape}</a></h3>
						<!-- Название товара (The End) -->

						{if $product->variants|count > 0}
							<!-- Селектбокс -->
							<select name="variant" class="variant dropdown {if $product->variants|count < 2}hide{/if}">
								{foreach $product->variants as $v}
									<option data-price="{$v->price|convert}" data-sku="{$v->sku}" value="{$v->id}">
										{$v->name}
									</option>
								{/foreach}
							</select>
							<!-- Селектбокс (The End) -->
						{/if}
					</div>

					<div class="bottom_bx">
						{if $product->variants|count > 0}
						<!-- Выбор варианта товара -->

								<!-- Артикул товара -->
								<div class="art_product {if !$product->variant->sku}hide{/if}">Код: <span>{$product->variant->sku}</span/></div>
								<!-- Артикул товара (The End) -->

								<div class="card_bottom {if $product->variant->price == 0}hide{/if}">
									<input type="submit" class="button" value="купить" data-result-text="добавлено"/>
								</div>
						<!-- Выбор варианта товара (The End) -->
				{else}
					Нет в наличии
				{/if}
				</div>
				</form>
			</li>
			<!-- Товар (The End)-->
		{/foreach}
	</div>



		<!-- Описание товара -->
{*		<div class="annotation">{$product->annotation}</div>*}
		<!-- Описание товара (The End) -->

	{* Связанные товары *}
	{if $related_products}
		<h2>Так же советуем посмотреть</h2>
		<!-- Список каталога товаров-->
		<ul class="tiny_products">
			{foreach $related_products as $related_product}
				<!-- Товар-->
				<li class="product">

					<!-- Фото товара -->
					{if $related_product->image}
						<div class="image">
							<a href="products/{$related_product->url}"><img src="{$related_product->image->filename|resize:200:200}" alt="{$related_product->name|escape}"/></a>
						</div>
					{/if}
					<!-- Фото товара (The End) -->

					<!-- Название товара -->
					<h3><a data-product="{$related_product->id}" href="products/{$related_product->url}">{$related_product->name|escape}</a></h3>
					<!-- Название товара (The End) -->

					{if $related_product->variants|count > 0}
						<!-- Выбор варианта товара -->
						<form class="variants" action="/cart">
							<table>
								{foreach $related_product->variants as $v}
									<tr class="variant">
										<td>
											<input id="related_{$v->id}" name="variant" value="{$v->id}" type="radio" class="variant_radiobutton"  {if $v@first}checked{/if} {if $related_product->variants|count<2} style="display:none;"{/if}/>
										</td>
										<td>
											{if $v->name}<label class="variant_name" for="related_{$v->id}">{$v->name}</label>{/if}
										</td>
										<td>
											{if $v->compare_price > 0}<span class="compare_price">{$v->compare_price|convert}</span>{/if}
											<span class="price">{$v->price|convert} <span class="currency">{$currency->sign|escape}</span></span>
										</td>
									</tr>
								{/foreach}
							</table>
							<input type="submit" class="button" value="в корзину" data-result-text="добавлено"/>
						</form>
						<!-- Выбор варианта товара (The End) -->
					{else}
						Нет в наличии
					{/if}


				</li>
				<!-- Товар (The End)-->
			{/foreach}
		</ul>
	{/if}



{include file='pagination.tpl'}	
<!-- Список товаров (The End)-->

{else}
Товары не найдены
{/if}
<!--Каталог товаров (The End)-->