<?php
header('Content-type: application/vnd.apple.pkpass');
header('Content-Disposition: attachment; filename="Coupon.pkpass"');
readfile('./Coupon.pkpass');
?>