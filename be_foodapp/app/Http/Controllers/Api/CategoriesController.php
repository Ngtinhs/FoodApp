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
}
