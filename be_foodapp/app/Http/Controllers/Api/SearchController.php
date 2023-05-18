<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Model\Posts;
use App\Models\Model\Product;
use App\Models\User;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function searchuser($key){
        $user = User::Where('users.name','like',"%$key%")->select('id','fname','lname','name','image','role')->get();
        return response()->json([$user],200);
    }
    public function searchpost($key){
        $post = Posts::join('users','posts.user_id','=','users.id')->select('posts.id','users.name','posts.detail','users.image as avatar','posts.image','posts.created_at')
            ->orderBy('posts.created_at','Desc')
            ->where('detail','like',"%$key%")->orWhere('users.name','like',"%$key%")->get();

        return response()->json([$post],200);
    }
    public function searchproduct($key){
        $product = Product::where('title','like',"%$key%")->orWhere('detail','like',"%$key%")->get();
        return response()->json([$product],200);
    }
}
