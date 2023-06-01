<?php

namespace App\Http\Controllers;

use App\Models\Model\Order;
use App\Models\Model\OrderDetail;
use App\Models\Model\Product;
use App\Models\Model\Coupon;
use App\Models\Model\Shopping;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ShoppingController extends Controller
{

    public function  index(Request $request){
        $validator = Validator::make($request->all(), [
            'user_id'=>'required',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
        $cart = Shopping::where('user_id',$request->user_id)->get();
        if($cart->count()>0){
            $total = 0;
            foreach ($cart as $item){
                $total+=$item->total;
            }
            return response()->json([$cart,'total'=>$total],200);

        }
        return response()->json("giohangrong",404);
    }



    public function insert(Request $request){
        $validator = Validator::make($request->all(), [
            'product_id' => 'required',
            'user_id' => 'required',
        ]);
    
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
    
        $product = Product::find($request->product_id);
    
        if (!$product) {
            return response()->json(['message' => 'Product not found'], 404);
        }
    
        $cartproduct = Shopping::where('product_id', $request->product_id)
            ->where('user_id', $request->user_id)
            ->first();
    
        if ($cartproduct == null) {
            $cart = new Shopping();
            $cart->product_id = $request->product_id;
            $cart->user_id = $request->user_id;
            $cart->name = $product->name;
            $cart->price = $product->price;
            $cart->quantity = 1;
            $cart->image = $product->image;
            $cart->total = ($cart->price * $cart->quantity);
            $cart->save();
            return response()->json($cart, 200);
        } else {
            // Kiểm tra số lượng món ăn muốn thêm vào giỏ hàng
            // nếu lớn hơn số lượng có sẵn trong kho, trả về lỗi
            if (($cartproduct->quantity + 1) > $product->quantity) {
                return response()->json(['message' => 'Hết món ăn'], 400);
            }
    
            $cartproduct->quantity += 1;
            $cartproduct->total = $cartproduct->price * $cartproduct->quantity;
            $cartproduct->save();
            return response()->json($cartproduct, 200);
        }
    }
    


    public function delete(Request $request){
        $validator = Validator::make($request->all(), [
            'product_id' => 'required',
            'user_id'=>'required',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
        $cartproduct = Shopping::where('product_id',$request->product_id)
            ->where('user_id',$request->user_id)->first();
        if($cartproduct!=null) {

            $cartproduct->product_id = $request->product_id;
            $cartproduct->user_id = $request->user_id;
            $cartproduct->quantity -= 1;
            $cartproduct->total = ($cartproduct->price * $cartproduct->quantity);
            if ($cartproduct->quantity <= 0) {
                $cartproduct->delete();
                return response()->json("da xoa", 200);
            }
            $cartproduct->save();
            return response()->json($cartproduct, 200);
        }

    }


    public function deleteproduct(Request $request){
        $validator = Validator::make($request->all(), [
            'product_id' => 'required',
            'user_id'=>'required',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
        $cartproduct = Shopping::where('product_id',$request->product_id)
            ->where('user_id',$request->user_id)->first();
        if($cartproduct!=null) {
                $cartproduct->delete();
                return response()->json("da xoa", 200);
        }
        return response()->json("khong ton tai", 404);

    }

    public function deleteall(Request $request){
        $validator = Validator::make($request->all(), [
            'user_id'=>'required',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
        $cartproduct = Shopping::where('user_id',$request->user_id)->get();
        if($cartproduct->count()>0) {
            foreach ($cartproduct as $item){
                $item->delete();
            }

                return response()->json("da xoa", 200);
        }
        return response()->json("khong ton tai", 404);

    }
    public function order(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required',
            'name' => 'required',
            'phone' => 'required',
            'address' => 'required',
            'note' => 'required',
        ]);
    
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
    
        $cart = Shopping::where('user_id', $request->user_id)->get();
    
        if ($cart->count() == 0) {
            return response()->json("giohangrong", 404);
        }
    
        $total = 0;
        $order = new Order();
        $order->name = $request->name;
        $order->phone = $request->phone;
        $order->address = $request->address;
        $order->note = $request->note;
        $order->status = 0;
        $order->total_price = 0;
        $order->user_id = $request->user_id;
        $order->save();
    
        foreach ($cart as $item) {
            $total += $item->total;
    
            $order_detail = new OrderDetail();
            $order_detail->product_id = $item->product_id;
            $order_detail->order_id = $order->id;
            $order_detail->name = $item->name;
            $order_detail->price = $item->price;
            $order_detail->quantity = $item->quantity;
            $order_detail->image = $item->image;
            $order_detail->save();
    
            // Giảm số lượng món ăn trong giỏ hàng từ cơ sở dữ liệu
            $product = Product::find($item->product_id);
            $product->decrement('quantity', $item->quantity);
            $product->save();
    
            $item->delete();
        }
    
        $order->total_price = $total;
    
        if ($request->has('coupon_code')) {
            $coupon = DB::table('coupons')->where('code', $request->coupon_code)->first();
            if ($coupon) {
                // Giảm giá trị của trường 'count' đi 1
                DB::table('coupons')->where('id', $coupon->id)->decrement('count');
            }
        }
    
        $order->save();
    
        return response()->json("datthanhcong", 200);
    }
    
    public function listorder($id,$status){
        if($status=="4"){
            $order = Order::where('user_id',$id)->get();
            foreach ($order as $item){
                if($item->status ==0 ) $item->status1 ="Đang xử lý";
                if($item->status ==1)  $item->status1 ="Đang giao hàng";
                if($item->status ==2 ) $item->status1 ="Thành công";
                if($item->status ==3 ) $item->status1 ="Đã hủy";
            }


            return response()->json($order,200);
        }
        $order = Order::where('user_id',$id)->where('status',$status)->get();
        foreach ($order as $item){
            if($item->status ==0 ) $item->status1 ="Đang xử lý";
            if($item->status ==1)  $item->status1 ="Đang giao hàng";
            if($item->status ==2 ) $item->status1 ="Thành công";
            if($item->status ==3 ) $item->status1 ="Đã hủy";
        }
        return response()->json($order,200);
    }
    public function huydon(Request $request)
{
    $validator = Validator::make($request->all(), [
        'order_id' => 'required',
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 401);
    }

    $order = Order::find($request->order_id);

    if (!$order) {
        return response()->json(['message' => 'Order not found'], 404);
    }

    // Kiểm tra trạng thái của đơn hàng
    if ($order->status != 0) {
        return response()->json(['message' => 'Cannot cancel the order'], 400);
    }

    $order->status = 3;
    $order->save();

    // Cập nhật lại số lượng món ăn đã hủy
    $orderDetails = OrderDetail::where('order_id', $order->id)->get();

    foreach ($orderDetails as $item) {
        $product = Product::find($item->product_id);
        $product->increment('quantity', $item->quantity);
        $product->save();
    }

    return response()->json($order, 200);
}

    public function  orderdetail ($id){
        $order_detai = OrderDetail::where('order_id',$id)->get();
        $total = 0 ;
        foreach ($order_detai as $item){
            $total+= $item->price*$item->quantity;
        }
        return response()->json([$order_detai,$total],200);
    }
    
    //Get ra tất cả order
    public function getAllOrders()
    {
        $orders = Order::all();

        return response()->json($orders, 200);
    }

    //updateStatus

    public function updateStatus(Request $request, $id)
    {
        $order = Order::find($id);
    
        if (!$order) {
            return response()->json(['message' => 'Order not found'], 404);
        }
    
        $status = $request->input('status');
    
        // Kiểm tra giá trị của status và cập nhật trạng thái đơn hàng
        switch ($status) {
            case 0:
            case 1:
            case 2:
            case 3:
                $order->status = $status;
                $order->save();
                break;
            default:
                return response()->json(['message' => 'Invalid status'], 400);
        }
    
        return response()->json(['message' => 'Status updated successfully']);
    }
     // Tính tổng doanh thu
     public function calculateTotalRevenue()
     {
         $totalRevenue = Order::where('status', 2)->sum('total_price');
         return response()->json(['totalRevenue' => $totalRevenue], 200);
     }

     public function calculateDailyRevenue()
{
    $orders = Order::where('status', 2)->get();
    $revenueByDate = [];

    foreach ($orders as $order) {
        $date = date('Y-m-d', strtotime($order->created_at));

        // Nếu ngày đã tồn tại trong mảng $revenueByDate, cộng tổng doanh thu vào ngày đó
        if (array_key_exists($date, $revenueByDate)) {
            $revenueByDate[$date] += $order->total_price;
        } else {
            // Ngược lại, thêm một cặp key-value mới vào mảng $revenueByDate
            $revenueByDate[$date] = $order->total_price;
        }
    }

    // Chuyển đổi mảng $revenueByDate thành mảng các đối tượng JSON
    $revenueArray = [];
    foreach ($revenueByDate as $date => $revenue) {
        $revenueItem = [
            $date => $revenue
        ];
        $revenueArray[] = $revenueItem;
    }

    return response()->json($revenueArray);
}


     
}

