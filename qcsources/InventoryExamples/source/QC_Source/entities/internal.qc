void(string modelname) Precache_Set = 
{
 precache_model(modelname);
 setmodel(self, modelname);
};