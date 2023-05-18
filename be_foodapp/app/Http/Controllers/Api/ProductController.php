<?php

namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use App\Models\Model\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProductController extends Controller
{
   public function index(){
       $product = Product::all();
       return response()->json($product,200);
   }
   public function newproduct(){
       $product = Product::
           join('categories','products.categories_id','=','categories.id')
           ->orderBy('products.created_at','desc')
           ->select('products.id','products.name','products.image','products.price','products.detail','products.quantity','categories.name as category','categories.id as category_id')->take(4)->get();
       return response()->json($product,200);
   }
   public function muanhieu(){
       $product = Product::
           join('categories','products.categories_id','=','categories.id')
           ->orderBy('products.created_at','desc')
           ->select('products.id','products.name','products.image','products.price','products.detail','products.quantity','categories.name as category','categories.id as category_id')->take(10)->get();
       return response()->json($product,200);
   } public function tatcasanpham(){
       $product = Product::
           join('categories','products.categories_id','=','categories.id')
           ->orderBy('products.created_at','desc')
           ->select('products.id','products.name','products.image','products.price','products.detail','products.quantity','categories.name as category','categories.id as category_id')->get();
       return response()->json($product,200);
   }
    public function searchproduct($keyword){
        $product = Product::
        join('categories','products.categories_id','=','categories.id')
            ->where('products.name','like','%'.$keyword.'%')
            ->orderBy('products.created_at','desc')
            ->select('products.id','products.name','products.image','products.price','products.detail','products.quantity','categories.name as category','categories.id as category_id')

            ->get();
        return response()->json($product,200);
    }
    public function searchdanhmuc($id){
        $product = Product::
        join('categories','products.categories_id','=','categories.id')
            ->where('products.categories_id',$id)
            ->orderBy('products.created_at','desc')
            ->select('products.id','products.name','products.image','products.price','products.detail','products.quantity','categories.name as category','categories.id as category_id')

            ->get();
        return response()->json($product,200);
    }
   public function create(Request $request){
       $validator = Validator::make($request->all(),[
                'name'=>'required',
                'categories_id'=>'required',
                'image'=>'required',
                'price' =>'required',
                'detail'=>'required',
                'quantity'=>'required',
       ]);
        if ($validator->fails()){
            return response()->json(['error'=>$validator->errors()],401);
        }
        $input = $request->all();
        if ($request->hasFile('image')){
            $image = $request->file('image');
            $name = time().'-'.$image->getClientOriginalName();
            $path = public_path('upload/product');
            $image->move($path,$name);
            $input['image']=$name;
        }

       $product = Product::create($input);
        return response()->json($product,200);

   }

   public function  update(Request $request,$id){
       $validator = Validator::make($request->all(),[
           'title'=>'required',
           'detail'=>'required',
           'image'=>'required',
           'price' =>'required',
           'discount'=>'required',
       ]);
       $product = Product::find($id);
       if (!$request->has('title')&&!$request->has('detail')&& !$request->has('price')&&!$request->has('discount')&& !$request->hasFile('image')){
           return response()->json(['errors'=>"Khong hop le"],401);
       }
       if ($request->has('title')){
           $product->title = $request->title;
       }
       if ($request->has('detail')){
           $product->detail = $request->detail;
       }
       if ($request->has('price')){
           $product->price = $request->price;
       }
       if ($request->has('discount')){
           $product->discount = $request->discount;
       }
       if($request->hasFile('image')){
           $image = $request->file('image');
           $name = time().'-'.$image->getClientOriginalName();
           $path = public_path('upload/products');
           $image->move($path,$name);
           if($product->image!="" && file_exists(public_path('upload/products/'.$product->image))){
               unlink(public_path('upload/products/'.$product->image));
           }
           $product->image= $name;
       }
       $product->save();
       return response()->json(['success'=>'Thành công','data'=>$product],200);

   }
   public function delete($id){
       $product = Product::find($id);
       if($product->image!="" && file_exists(public_path('upload/products/'.$product->image))){
           unlink(public_path('upload/products/'.$product->image));
       }
       $product->delete();
       return response()->json(['success'=>'Thành công','data'=>$product],200);
   }
   public function detail($id){
       $product = Product::find($id);
       return response()->json($product,200);
   }
}
