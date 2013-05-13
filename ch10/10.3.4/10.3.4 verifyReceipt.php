<?php
    /**
     * 验证电子凭证
     *
     * @param   string  $receipt    Base-64编码数据
     * @param   bool    $isSandbox  可选参数true是进行test验证
     * @throws  Exception   验证失败抛出异常
     * @return  array       返回凭证信息，包括产品ID和数量
     */
    function getReceiptData($receipt, $isSandbox = false)
    {
        // 确定使用哪个网站验证凭证
        if ($isSandbox) {
            //app store 测试验证网站
            $endpoint = 'https://sandbox.itunes.apple.com/verifyReceipt';
        }
        else {
            //app store 产品验证网站
            $endpoint = 'https://buy.itunes.apple.com/verifyReceipt';
        }
 
        // 构建POST数据
        $postData = json_encode(
            array('receipt-data' => $receipt)
        );
 
        // 创建cURL请求对象
        $ch = curl_init($endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
	    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);  
	    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
 
        // 执行cURL请求，返回应答数据
        $response = curl_exec($ch);
        $errno    = curl_errno($ch);
        $errmsg   = curl_error($ch);
        curl_close($ch);
 
        // 确认请求成功
        if ($errno != 0) {
            throw new Exception($errmsg, $errno);
        }
 
        // 解析应答数据
        $data = json_decode($response);
 
        // 确认应答数据是有效的JSON字符串
        if (!is_object($data)) {
            throw new Exception('Invalid response data');
        }
 
        // 验证返回成功
        if (!isset($data->status) || $data->status != 0) {
            throw new Exception('Invalid receipt');
        }
 
        // 建立应答数组，并且返回
        return array(
            'quantity'       =>  $data->receipt->quantity,
            'product_id'     =>  $data->receipt->product_id,
            'transaction_id' =>  $data->receipt->transaction_id,
            'purchase_date'  =>  $data->receipt->purchase_date,
            'app_item_id'    =>  $data->receipt->app_item_id,
            'bid'            =>  $data->receipt->bid,
            'bvrs'           =>  $data->receipt->bvrs
        );
    }
 
    // 从请求体中取出电子凭证数据
    $receipt   = $_POST['receipt'];
    // 从请求体中取出是否使用沙箱标识
    $isSandbox = (bool) $_POST['sandbox'];

    // 验证凭证
    try {
        $info = getReceiptData($receipt, $isSandbox);
		$res = array_merge($info, array('ResultCode' => 0));    
		//验证结果以JSON编码方式，返回给客户端
		echo json_encode($res);
    }
    catch (Exception $ex) {
        // 验证失败
		echo '{"ResultCode":-2}';
    }
?>