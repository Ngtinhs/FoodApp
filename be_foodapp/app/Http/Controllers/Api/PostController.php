<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Model\Comment;
use Illuminate\Http\Request;
use App\Models\Model\Posts;
use App\Models\User;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Validator;
class PostController extends Controller
{
    public function index(){
        // $post = Posts::join('users','posts.user_id','=','users.id')->select('posts.id','users.name','posts.detail','users.image','posts.image','posts.created_at')->orderBy('posts.created_at','Desc')->get();
        $post = Posts::join('users','posts.user_id','=','users.id')->select('posts.id','users.name','posts.detail','users.image as avatar','posts.image','posts.created_at')->orderBy('posts.created_at','Desc')->get();
        return response()->json([$post],Response::HTTP_OK);
    }
    public function  getpostbyuser($id){
        $post = Posts::where('posts.user_id',$id)->join('users','posts.user_id','=','users.id')
            ->select('posts.id','users.name','posts.detail','users.image as avatar','posts.image','posts.created_at')->orderBy('posts.created_at','Desc')->get();
        return response()->json([$post],Response::HTTP_OK);
//        $checkuser = Posts::where('posts.user_id',$user->id)
//            ->orderBy('posts.created_at','Desc')
//            ->get();
    }
    public function store(Request $request)
    {
//        $validator = Validator::make($request->all(),[
//                'detail'=>'required',
//        ]);
//        if ($validator->fails()){
//            return response()->json(['error'=>$validator->errors()],401);
//        }
        if (!$request->has('detail')&& !$request->hasFile('image')){
            return response()->json(['errors'=>"Khong hop le"],401);
        }
        $input = $request->all();
        if($request->hasFile('image')){
            $image = $request->file('image');
            $name = time().'-'.$image->getClientOriginalName();
            $path = public_path('upload/posts');
            $image->move($path,$name);
            $input['image']= $name;
        }
        $input['user_id'] = $request->user()->id;
        // $input['created_at'] = now();
        $post = Posts::create($input);
        return response()->json(['success'=>'Thành công','data'=>$post],200);
    }
    public function update(Request $request , $id){
        $post = Posts::find($id);
        if (!$request->has('detail')&& !$request->hasFile('image')){
            return response()->json(['errors'=>"Khong hop le"],401);
        }
        if($request->hasFile('image')){
            $image = $request->file('image');
            $name = time().'-'.$image->getClientOriginalName();
            $path = public_path('upload/posts');
            $image->move($path,$name);
            if($post->image!="" && file_exists(public_path('upload/posts/'.$post->image))){
                unlink(public_path('upload/posts/'.$post->image));
            }
            $post->image= $name;
        }
        if($request->has('detail')){
            $post->detail = $request->detail;
        }
        $post->save();
        return response()->json(['success'=>'Thành công','data'=>$post],200);
    }
    public function delete(Request $request , $id){
        $post = Posts::find($id);

        $comment = Comment::where('post_id',$id)->get();
        if(isset($comment[0])){
            foreach ($comment as $item){
                if($item->image!="" && file_exists(public_path('upload/comments/'.$item->image))){
                    unlink(public_path('upload/posts/'.$item->image));
                }
                $item->delete();
            }
        }
        if($post->image!="" && file_exists(public_path('upload/posts/'.$post->image))){
            unlink(public_path('upload/posts/'.$post->image));
        }
        $post->delete();
        return response()->json(['success'=>'Thành công','data'=>$post,'ok'=>$comment],200);
    }
    public function detail($id){
        $post = Posts::join('users','posts.user_id','=','users.id')
            ->select('posts.id','users.name','posts.detail','users.image as avatar','posts.image','posts.created_at')->where('posts.id',$id)->first();
//        $comment = Comment::where("post_id",$id);
        return response()->json([$post],200);
    }
}
