<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;

use App\Models\Model\Message;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function getmessage(Request $request, $to){
        $from =   $request->user()->id;
        $message =  Message::where('from',$from)->where('to',$to)
            ->orWhere('from',$to)->where('to',$from)
            ->orderBy('created_at','DESC')
            ->join('users','messages.to','=','users.id')->select('messages.*','users.name')
            ->get();
        return response()->json([$message],200);
    }
    public function  getlistmessage(Request $request){
            $mesage = Message::where('from',$request->user()->id)->select('id','from','to','message','image','created_at')
                ->orderBy('created_at','DESC')->join('users','messages.to','=','users.id')->select('messages.*','users.name')
                ->get()->unique('to');
        return response()->json([$mesage],200);
    }
    public function sendmessage(Request $request,$to){
          $mes= new Message();
          $from = $request->user()->id;
        if (!$request->has('message')&& !$request->hasFile('image')){
            return response()->json(['errors'=>"Khong hop le"],401);
        }
        if ($request->has('message')){
            $mes->message = $request->message;
        }
        if ($request->hasFile('image')){
            if($request->hasFile('image')){
                $image = $request->file('image');
                $name = time().'-'.$image->getClientOriginalName();
                $path = public_path('upload/messages');
                $image->move($path,$name);
                $mes->image= $name;
            }
        }
        $mes->to = $to;
        $mes->from = $from;
        $mes->save();

        return response()->json([$mes],200);
    }
    public function  delete($id){
        $mes = Message::find($id);
        if($mes->image!="" && file_exists(public_path('upload/messages/'.$mes->image))){
            unlink(public_path('upload/messages/'.$mes->image));
        }
        $mes->delete();
        return response()->json(['success'=>'Thành công'],200);
    }
    public function deletemes(Request $request,$to){
        $from =   $request->user()->id;
        $message =  Message::where('from',$from)->where('to',$to)
            ->orWhere('from',$to)->where('to',$from)
            ->orderBy('created_at','DESC')
            ->join('users','messages.to','=','users.id')->select('messages.*','users.name')
            ->get();
        if(isset($message[0])){
            foreach ($message as $item){
                if($item->image!="" && file_exists(public_path('upload/messages/'.$item->image))){
                    unlink(public_path('upload/messages/'.$item->image));
                }
                $item->delete();
            }
            return response()->json(['success'=>'Thành công'],200);
        }
        return response()->json(['success'=>'Không Thành công'],401);

    }
}
