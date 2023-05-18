<?php

namespace App\Http\Controllers;

use App\Models\Model\Order;
use App\Models\Model\OrderDetail;
use App\Models\Model\Product;
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
            'user_id'=>'required',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
        $cartproduct = Shopping::where('product_id',$request->product_id)
            ->where('user_id',$request->user_id)->first();
        if($cartproduct==null){
            $product = Product::find($request->product_id);
            $cart = new Shopping();
            $cart->product_id = $request->product_id;
            $cart->user_id = $request->user_id;
            $cart->name = $product->name;
            $cart->price = $product->price;
            $cart->quantity = 1;
            $cart->image =$product->image;
            $cart->total = ($cart->price*$cart->quantity);
            $cart->save();
            return response()->json($cart,200);
        }
        else{
            $cartproduct->quantity=$cartproduct->quantity+1;
            $cartproduct->total = $cartproduct->price * $cartproduct->quantity;
            $cartproduct->save();
            return response()->json($cartproduct,200);
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
 public function order(Request $request){
     $validator = Validator::make($request->all(), [
         'user_id'=>'required',
         'name'=>'required',
         'phone'=>'required',
         'address'=>'required',
         'note'=>'required',
     ]);
     if ($validator->fails()) {
         return response()->json($validator->errors(), 401);
     }
     $cart = Shopping::where('user_id',$request->user_id)->get();
     if($cart->count()==0)  return response()->json("giohangrong", 404);
        $total = 0;
        $order = new Order();
        $order->name = $request->name;
        $order->phone = $request->phone;
        $order->address = $request->address;
        $order->note = $request->note;
        $order->status =0;
        $order->total_price =0;
        $order->user_id = $request->user_id;
        $order->save();
     foreach ($cart as $item){
            $total += $item->total;
            $order_detail = new OrderDetail();
            $order_detail->product_id = $item->product_id;
            $order_detail->order_id = $order->id;
            $order_detail->name = $item->name;
            $order_detail->price = $item->price;
            $order_detail->quantity = $item->quantity;
            $order_detail->image = $item->image;
            $order_detail->save();
            $item->delete();
     }
     $order->total_price = $total;
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
    public function huydon(Request $request){
        $order= Order::find($request->order_id);
        $order->status = 3;
        $order->save();
        return response()->json($order,200);
    }
    public function  orderdetail ($id){
        $order_detai = OrderDetail::where('order_id',$id)->get();
        $total = 0 ;
        foreach ($order_detai as $item){
            $total+= $item->price*$item->quantity;
        }
        return response()->json([$order_detai,$total],200);
    }
}
