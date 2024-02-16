// Аяксовая корзина
$('form.variants').live('submit', function(e) {
	e.preventDefault();
	let button = $(this).find('input[type="submit"]');
	if($(this).find('input[name=variant]:checked').size()>0)
		variant = $(this).find('input[name=variant]:checked').val();
	if($(this).find('select[name=variant] option:selected').size()>0) {
		variant = $(this).find('select[name=variant] option:selected').val();
	}

	$.ajax({
		url: "ajax/cart.php",
		data: {variant: variant},
		dataType: 'json',
		success: function(data){
			$('#cart_informer').html(data);
			if(button.attr('data-result-text'))
				button.val(button.attr('data-result-text'));
		}
	});
	let o1 = $(this).offset();
	let o2 = $('#cart_informer').offset();
	let dx = o1.left - o2.left;
	let dy = o1.top - o2.top;
	let distance = Math.sqrt(dx * dx + dy * dy);
	$(this).closest('.product').find('.image img').effect("transfer", { to: $("#cart_informer"), className: "transfer_class" }, distance);	
	$('.transfer_class').html($(this).closest('.product').find('.image').html());
	$('.transfer_class').find('img').css('height', '100%');
	return false;
});


$(function() {
	$('select[name=variant]').change(function () {
		let this_product = $(this).closest('.product');
		let sku = $(this).find('option:selected').data('sku');
		let price = $(this).find('option:selected').data('price');

		this_product.find('.price span').text(price);
		if(price == 0) {
			this_product.find('.price').addClass('hide');
		}
		else {
			this_product.find('.price').removeClass('hide');
		}

		this_product.find('.art_product span').text(sku);
		if(sku == '') {
			this_product.find('.art_product').addClass('hide');
		}
		else {
			this_product.find('.art_product').removeClass('hide');
		}

	});
});
/*
// Аяксовая корзина
$('a[href*="cart?variant"]').live('click', function(e) {
	e.preventDefault();
	//variant_id = $(this).attr('id');
	
	href = $(this).attr('href');
	pattern = /\/?cart\?variant=(\d+)$/;
	variant_id = pattern.exec(href)[1];
	
	link = $(this);
	$.ajax({
		url: "ajax/cart.php",
		data: {variant: variant_id},
		dataType: 'json',
		success: function(data){
			$('#cart_informer').html(data);
			//if(link.attr('added_text'))
			//	link.html(link.attr('added_text'));
			//link.attr('href', '/cart');
		}
	});

	var o1 = $(this).offset();
	var o2 = $('#cart_informer').offset();
	var dx = o1.left - o2.left;
	var dy = o1.top - o2.top;
	var distance = Math.sqrt(dx * dx + dy * dy);

	$(this).closest('.product').find('.image img').effect("transfer", { to: $("#cart_informer"), className: "transfer_class" }, distance);	
	$('.transfer_class').html($(this).closest('.product').find('.image').html());
	$('.transfer_class').find('img').css('height', '100%');
	return false;
});
*/