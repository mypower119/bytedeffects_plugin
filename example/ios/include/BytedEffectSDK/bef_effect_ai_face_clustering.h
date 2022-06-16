//
// Created by wangliu on 2019-08-01.
//

#ifndef ANDROIDDEMO_BEF_EFFECT_AI_FACE_CLUSTERING_H
#define ANDROIDDEMO_BEF_EFFECT_AI_FACE_CLUSTERING_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

#include "bef_effect_ai_public_define.h"

typedef enum {
    BEF_RecognitionfThreshold = 1, // {zh} 人脸识别阈值，值越大，召回越高，默认值0.3 {en} Face recognition threshold, the larger the value, the higher the recall, the default value is 0.3
    BEF_FeatureDim = 2,            // {zh} 特征长度,默认为512 {en} Feature length, default is 512
    BEF_ClustingThreshold = 3,     // {zh} 聚类时，两个临时类被合并的距离阈值 越小约准，但是越不全，容易漏掉同一个人差异比较大的脸,越大越全，但是越不准，容易把不是同一人但是相似的脸聚进来 {en} When clustering, the distance threshold between the two temporary classes is merged, the smaller the approximate, but the less complete, it is easy to miss the same person with a larger difference in the face, the larger the more complete, but the more inaccurate, it is easy to gather not the same person but similar faces in
    //  {zh} 默认值dist_threshold = 1.11 * 0.82;  {en} Default value dist_threshold = 1.11 * 0.82;
            BEF_LinkageType = 4,           //  {zh} 链接方法,默认AvgLinkage  {en} Link method, default AvgLinkage
    BEF_DistanceType = 5,          //  {zh} 距离度量方法 默认Consine  {en} Distance measure method, default Consine
    BEF_HP1 = 6,                   //  {zh} 超参1, 默认0.765;  {en} Super parameter 1, default 0.765;
    BEF_HP2 = 7                  //  {zh} 超参2,默认0.178  {en} Super Parameter 2, default 0.178

} bef_ai_fc_param_type;

typedef enum {
    BEF_EUCLIDEAN = 1,       // {zh} 欧式距离 {en} European distance
    BEF_COSINE = 2,          // {zh} 余弦距离, 默认值 {en} Cosine distance, default
    BEF_BHATTACHARYYAH = 3,  // {zh} 巴氏距离 {en} Pap distance
}bef_ai_fc_distance_type;

typedef enum {
    BEF_AVERAGE_LINKAGE = 1,  /* choose average distance  default*/
    BEF_CENTROID_LINKAGE = 2, /* choose distance between cluster centroids */
    BEF_COMPLETE_LINKAGE = 3, /* choose maximum distance */
    BEF_SINGLE_LINKAGE = 4,   /* choose minimum distance */
}bef_ai_fc_link_type;


typedef struct {
    int * ids;
    int num;
}bef_ai_fc_node;

typedef struct {
    bef_ai_fc_node * cluster;
    int clusters;
}bef_ai_fc_cluster;


/** {zh} 
 * @brief           创建人脸聚类句柄
 * @param handle    创建的人脸聚类句柄
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief           Create face clustering handle
 * @param handle    Create face clustering handle
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *         Success returns BEF_RESULT_SUC, failure returns the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API bef_effect_result_t bef_effect_ai_fc_create(bef_effect_handle_t *handle);

/** {zh} 
 * @brief 人脸聚类参数设置
 * @param handle 人脸聚类句柄
 * @param type param type 参数类型
 * @param value 参数值
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Face clustering parameter settings
 * @param handle  face clustering handle
 * @param type param type parameter type
 * @param value  parameter value
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *          successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API bef_effect_result_t bef_effect_ai_fc_set_param(bef_effect_handle_t handle, bef_ai_fc_param_type type, float value);

/** {zh} 
 *@brief 人脸特征聚类
 *@param features         人脸特征，大小为 num_samples * FACE_FEATURE_DIM
 *@param num_samples      人脸的数量
 *@param clusters         输出的人脸聚类结果
 */
/** {en} 
 *@brief Face feature clustering
 *@param features         face features, size num_samples * FACE_FEATURE_DIM
 *@param num_samples      number of faces
 *@param clusters         output face clustering results
 */

BEF_SDK_API bef_effect_result_t  bef_effect_ai_fc_do_clustering(bef_effect_handle_t handle,
                                                                    float *const features,
                                                                 const int num_samples,
                                                                int *clusters);
/** {zh} 
 * 释放人脸聚类句柄
 * @param handle
 * @return
 */
/** {en} 
 * Release face clustering handle
 * @param handle
 * @return
 */
BEF_SDK_API bef_effect_result_t bef_effect_ai_fc_release(bef_effect_handle_t handle);


/** {zh} 
 * @brief 人脸聚类授权
 * @param [in] handle Created face detect handle
 *                    已创建的人脸聚类句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Face clustering authorization
 * @param  [in] handle Created face detect handle
 *                    created face clustering handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         successfully return BEF_RESULT_SUC, authorization code illegally return BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_define for details.
 */
#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_cluster_check_license(JNIEnv *env, jobject context,
                                                                 bef_effect_handle_t handle,
                                                                 const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_cluster_check_license(bef_effect_handle_t handle, const char *licensePath);
#endif
#endif

BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_cluster_check_online_license(bef_effect_handle_t handle, const char *licensePath);
#endif //ANDROIDDEMO_BEF_EFFECT_AI_FACE_CLUSTERING_H
