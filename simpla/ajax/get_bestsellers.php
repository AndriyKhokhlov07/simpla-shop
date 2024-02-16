<?php

require_once('../../api/Simpla.php');
$simpla = new Simpla();

$category_id = $simpla->request->get('category_id', 'integer');
$product_id = $simpla->request->get('product_id', 'integer');

if(!empty($category_id))
    $bestsellers = $simpla->bestsellers->get_bestsellers(array('category_id'=>$category_id));
else
    $bestsellers = $simpla->bestsellers->get_bestsellers();

$options = array();
if(!empty($product_id))
{
    $opts = $simpla->bestsellers->get_product_options($product_id);
    foreach($opts as $opt)
        $options[$opt->bestsellers_id] = $opt;
}

foreach($bestsellers as &$f)
{
    if(isset($options[$f->id]))
        $f->value = $options[$f->id]->value;
    else
        $f->value = '';
}

header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
print json_encode($bestsellers);

