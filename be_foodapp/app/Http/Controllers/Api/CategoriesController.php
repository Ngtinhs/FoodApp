<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Model\Categories;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CategoriesController extends Controller
{
    public function insert(Request $request){

        $validator = Validator::make($request->all(),[
           'name'=>'required',
            'image'=>'required',
        ]);

        if ($validator->fails()){
            return response()->json(['error'=>$validator->errors()],401);
        }
        $categories = new Categories();
        $categories->name = $request->name;
        if ($request->hasFile('image')){
            $image = $request->file('image');
            $name = time().'-'.$image->getClientOriginalName();
            $path = public_path('upload/categories');
            $image->move($path,$name);
           $categories->image=$name;
        }
        $categories->save();
        return response()->json($categories,200);
    }
    public function index(){
        $categories = Categories::all();
        return response()->json($categories,200);
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'sometimes',
            'image' => 'sometimes',
        ]);
    
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 401);
        }
    
        $category = Categories::findOrFail($id);
    
        if ($request->has('name')) {
            $category->name = $request->name;
        }
    
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $name = time() . '-' . $image->getClientOriginalName();
            $path = public_path('upload/categories');
            $image->move($path, $name);
            $category->image = $name;
        }
    
        $category->save();
    
        return response()->json($category, 200);
    }
    
    public function delete($id)
    {
        $category = Categories::findOrFail($id);
        $category->delete();

        return response()->json(['message' => 'Category deleted successfully'], 200);
    }
}
