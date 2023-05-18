<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Model\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function  index($post_id){
        $comment = Comment::join('users','comments.user_id','=','users.id')
            ->select('comments.id','users.name','users.image as avatar','comments.post_id','comments.user_id','comments.title','comments.image','comments.created_at')
            ->where('post_id',$post_id)
            ->get();
        return response()->json([$comment],200);
    }
    public function  newcomment(Request $request,$post_id){
        $comment = new Comment();
        $comment->post_id = $post_id;
        if (!$request->has('title')&& !$request->hasFile('image')){
            return response()->json(['errors'=>"Khong hop le"],401);
        }
        if ($request->has('title')){
            $comment->title = $request->title;
        }
        if ($request->hasFile('image')){
            if($request->hasFile('image')){
                $image = $request->file('image');
                $name = time().'-'.$image->getClientOriginalName();
                $path = public_path('upload/comments');
                $image->move($path,$name);
                $comment->image= $name;
            }
        }
        $comment->user_id = $request->user()->id;
        $comment->save();

        return response()->json([$comment],200);
    }
    public function  delete($id){
            $comment = Comment::find($id);
        if($comment->image!="" && file_exists(public_path('upload/comments/'.$comment->image))){
            unlink(public_path('upload/comments/'.$comment->image));
        }
        $comment->delete();
        return response()->json(['success'=>'Thành công'],200);
    }
}
