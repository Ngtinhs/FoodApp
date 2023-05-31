<?php

namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use App\Models\Model\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

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
   } 
   
   public function tatcasanpham(){
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
                'quantity' => 'required|integer|min:0'
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

   public function update(Request $request, $id){
    $validator = Validator::make($request->all(), [
        'name' => 'sometimes',
        'categories_id' => 'sometimes',
        'price' => 'sometimes',
        'detail' => 'sometimes',
        'quantity' => 'sometimes|integer|min:0',
    ]);

    if ($validator->fails()){
        return response()->json(['error' => $validator->errors()], 401);
    }

    $input = $request->all();
    $product = Product::findOrFail($id);

    if ($request->hasFile('image')){
        // Xóa ảnh cũ (nếu có)
        if (file_exists(public_path('upload/product/' . $product->image))) {
            unlink(public_path('upload/product/' . $product->image));
        }

        // Lưu ảnh mới
        $image = $request->file('image');
        $name = time() . '-' . $image->getClientOriginalName();
        $path = public_path('upload/product');
        $image->move($path, $name);
        $input['image'] = $name;
    }

    $product->update($input);

    return response()->json($product, 200);
}

   public function delete($id)
   {
       $product = Product::find($id);

       if (!$product) {
           return response()->json(['error' => 'Product not found'], 404);
       }

       if ($product->image != "" && file_exists(public_path('upload/product/' . $product->image))) {
           unlink(public_path('upload/product/' . $product->image));
       }

       $product->delete();

       return response()->json(['success' => 'Product deleted successfully'], 200);
   }
   public function detail($id){
       $product = Product::find($id);
       return response()->json($product,200);
   }


 public function datnhieu()
{
    $orderedProducts = DB::table('order_details')
        ->select('product_id', DB::raw('COUNT(*) as count'))
        ->groupBy('product_id')
        ->havingRaw('COUNT(*) > 0')
        ->orderByDesc('count')
        ->get();

    $productIds = $orderedProducts->pluck('product_id');

    $products = DB::table('products')
        ->join('order_details', 'products.id', '=', 'order_details.product_id')
        ->whereIn('products.id', $productIds)
        ->select('products.id', 'products.name', 'products.categories_id', 'products.image', 'products.price', 'products.detail', 'products.quantity', 'products.created_at', 'products.updated_at', DB::raw('SUM(order_details.quantity) as so_luong_ban'))
        ->groupBy('products.id', 'products.name', 'products.categories_id', 'products.image', 'products.price', 'products.detail', 'products.quantity', 'products.created_at', 'products.updated_at')
        ->orderByRaw(DB::raw("FIELD(products.id, " . $productIds->join(',') . ")"))
        ->get();

    return response()->json($products);
}


}
