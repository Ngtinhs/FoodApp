<?php

namespace App\Http\Controllers\Api;
use Carbon\Carbon;
use Carbon\Traits\Date;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Model\Posts;
class UserController extends Controller
{
    public $successStatus =200;
    //login
    public function login(){
        if ( Auth::attempt(['email' => request('email'), 'password' => request('password')]))
        {
            $user = Auth::user();
            $success['token'] = $user->createToken('Client')->accessToken;
            $success['users']=$user;
            $success['id']=$user->id;
            $success['name']=$user->name;
            $success['role']=$user->role;
            $success['image']=$user->image;
            return response()->json($success,$this->successStatus);
        }
        else
        {
            return response()->json(['error'=>'Unauthorised'],401);
        }


    }


    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'fname' => 'required',
            'lname'=>'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required',
            'c_password' => 'required|same:password',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }
        $input = $request->all();
        $user =new  User;
        $user->fname =  $input['fname'];
        $user->lname =  $input['lname'];
        $user->name =  $input['fname'].' '.$input['lname'];
        $user->image = 'avt.png';
        $user->email = $input['email'];
        $user->password = bcrypt($input['password']);
        $user->status = 1;
        $user->role = 2;
        $user->save();
        $success['token'] =  $user->createToken('MyApp')-> accessToken;
        $success['users']=$user;
        $success['id']=$user->id;
        $success['name']=$user->name;
        $success['phone']=$user->phone;
        $success['address']=$user->address;
        $success['email']=$user->email;
        $success['role']=$user->role;
        $success['image']=$user->image;
        return response()->json($success, $this->successStatus);
    }

    public function detail(){
        $user = Auth::user();
        return response()->json($user,200);
    }
    public function detailuserbyid($id){
        $user = User::find($id);
        return response()->json([$user],200);
    }
    public function  changeimage(Request $request){
        $user = Auth::user();
        if (!$request->hasFile('avatar')){
            return response()->json(['errors'=>"Thieeus avatar"],401);
        }
        if($request->hasFile('avatar')){
            $image = $request->file('avatar');
            $name = time().'-'.$image->getClientOriginalName();
            $path = public_path('upload/avatar');
            $image->move($path,$name);
            if ($user->image!="avt.png" && file_exists(public_path('upload/avatar/'.$user->image))){
                    unlink(public_path('upload/avatar/'.$user->image));
            }
            $user->image= $name;
            $user->save();
            return response()->json(['success'=>'Thanh cong'],200);
        }
        return response()->json(['fail'=>'That bai'],401);
    }
    public function  changeinfo(Request $request){
        $validator = Validator::make($request->all(), [
            'name' => 'required',
            'phone'=>'required',
            'address'=>'required',
//            'email'=>'unique:users.email'
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 401);
        }

        $user = User::find($request->user_id);
//        if (!$request->hasFile('avatar')){
//            return response()->json(['errors'=>"Thieeus avatar"],401);
//        }
        if($request->hasFile('avatar')){
            $image = $request->file('avatar');
            $name = time().'-'.$image->getClientOriginalName();
            $path = public_path('upload/avatar');
            $image->move($path,$name);
            if ($user->image!="avt.png" && file_exists(public_path('upload/avatar/'.$user->image))){
                unlink(public_path('upload/avatar/'.$user->image));
            }
            $user->image= $name;
            $user->save();
            return response()->json(['success'=>'Thanh cong'],200);
        }
        $user->name = $request->name;
        $user->phone    =$request->phone;
        $user->address    =$request->address;

        $user->save();
        $success['users']=$user;
        $success['id']=$user->id;
        $success['name']=$user->name;
        $success['phone']=$user->phone;
        $success['address']=$user->address;
        $success['email']=$user->email;
        $success['role']=$user->role;
        $success['image']=$user->image;
        return response()->json($success,200);
    }
}
