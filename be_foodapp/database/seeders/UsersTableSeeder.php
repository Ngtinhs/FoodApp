<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
       DB::table('users')->insert(
           ['fname'=>'Tính',
            'lname'=>'Nguyễn Văn Đức',
            'name'=>'Nguyễn Văn Đức Tính',
            'image'=>'avt.png',
            'email'=>'admin@gmail.com',
            'phone'=>'0983743359',
            'password'=>bcrypt('admin'),
            'status'=>1,
            'role'=>1,
           ]
       );
    }
}
