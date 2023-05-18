<?php

namespace App\Models\Model;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
//use DateTimeInterface;
class Posts extends Model
{


//    /**
//     * Prepare a date for array / JSON serialization.
//     *
//     * @param  \DateTimeInterface  $date
//     * @return string
//     */
//    protected function serializeDate(DateTimeInterface $date)
//    {
//        return $date->format('Y-m-d H:i:s');
//    }
    use HasFactory;
    protected $guarded = ['id'];
    protected $casts = [
        'user_id' => 'integer',
        'title' => 'string',
        'detail' => 'string',
        'image' => 'string',
        'price' => 'integer',
        'discount' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
];
}
