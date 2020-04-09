<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * id
 * description
 * reports_id
 * reported_id 
 */ 
class Report extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'report';

    /**
     * @var array
     */
    protected $fillable = ['description', 'reports_id', 'reported_id']; 

    /**
     * @return 
     */
    public function userReports()
    {
        return $this->belongsTo(User::class, 'reports_id');
    }

    public function Userreported() {
        return $this->belongsTo(User::class, 'reported_id');
    }

}
